# [译]Android 开发中避免糟糕问题的3类单元测试


> 原文：[3 unit tests to avoid bad surprises on Android](http://jeremie-martinez.com/2016/02/16/unit-tests/)
> 作者：[Jérémie Martinez](https://github.com/jeremiemartinez)
> 译者：[lovexiaov](http://www.jianshu.com/users/7378dce2d52c/latest_articles)

在持续分发的过程中，单元测试十分必要。它们应该简短，快速和可靠。有时它们是查找错误和避免将 bug 带到产品中的唯一方法。本文将会介绍3类单元测试，通过专注 Android 应用的关键方面：权限，SharedPreferences 和 SQLite 数据库来避免开发中的糟糕问题。在发布之前找到它们，避免糟糕问题！

首先，你需要知道这些单元测试基于 [Robolectric](https://github.com/robolectric/robolectric) 和 [Truth](https://github.com/google/truth) （请在我[之前文章](http://jeremie-martinez.com/2015/11/05/truth-android/)中详细了解）：

```gradle
testCompile "org.robolectric:robolectric:3.0"
testCompile "com.google.truth:truth:0.27"
```

## 控制你的权限

管理好权限往往是一个应用成功的关键。我们听说过很多由于滥用权限导致应用骂声一片的例子。在 Android 设备上，用户十分在意新应用安装时申请的权限。实际上，如果他们认为你申请了不必要的权限，你的评分（在 PlayStore/应用商店上可以查看）将极速降低。

有时，如果不注意，你新添加的库可能会申请你不需要/想要的权限（比如 Play Service），而且你只有在向 Play Store 提交应用时才会发现此问题。如下这个单元测试可以避免此类不快的事情发生：

```java
@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public final class PermissionsTest {

    private static final String[] EXPECTED_PERMISSIONS = {
            […]
    };

    private static final String MERGED_MANIFEST =
        "build/intermediates/manifests/full/debug/AndroidManifest.xml"

    @Test
    public void shouldMatchPermissions() {
        AndroidManifest manifest = new AndroidManifest(
                Fs.fileFromPath(MERGED_MANIFEST),
                null,
                null
        );

        assertThat(new HashSet<>(manifest.getUsedPermissions())).
                containsOnly(EXPECTED_PERMISSIONS);
    }
}
```

该测试基于 Robolectric 来解析 Android 配置清单文件实现。当 Gradle 构建 APK 时，其中的一个步骤是组合所有你使用的库的清单文件，并将他们合并到一起。然后将合并后的清单文件打包到二进制文件中。该测试将会检索合并后的清单文件，提取权限并验证它们是否匹配期望的权限。使用构建的中间状态并不是理想，但这是我目前发现的唯一解决方案。

另一个缺陷是当你确实想要添加一个新权限时，你需要同时更新该单元测试。我承认这不是理想的解决方案，但有时你必须为了安全作出权衡。当你想做持续分发（参考我此前的[文章](http://jeremie-martinez.com/2016/01/14/devops-on-android/)）并且要保证权限未被变更时更要这样做。

## 验证你的 SharedPreferences

许多应用都使用 `SharedPreferences` 存储数据。它们是应用的核心部分，必须被重度测试。为了阐述此例子，我设计了一个简单的 `SharedPreferences` 包装类，我认为你们在自己的应用中也会有类似的操作。

```java
public class Preferences {

    private static final String NOTIFICATION = "NOTIFICATION";
    private static final String USERNAME = "USERNAME";

    private final Context context;

    public Preferences(Context context) {
        this.context = context;
    }

    public String getUsername() {
        return getPreferences().getString(USERNAME, null);
    }

    public void setUsername(String username) {
        getPreferences().edit().
                       putString(USERNAME, username).
                       apply();
    }

    public boolean hasNotificationEnabled() {
        return getPreferences().getBoolean(NOTIFICATION, false);
    }

    public void setNotificationEnabled(boolean enable) {
        getPreferences().edit().
                        putBoolean(NOTIFICATION, enable).
                        apply();
    }

    private SharedPreferences getPreferences() {
        return context.getSharedPreferences("user_prefs", MODE_PRIVATE);
    }
}
```

幸好有 Robolectric，测试它们将变得十分简单：

```java
@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public final class PreferencesTest {

    private Preferences preferences;

    @Before
    public void setUp() {
        preferences = new Preferences(RuntimeEnvironment.application);
    }

    @Test
    public void should_set_username() {
        preferences.setUsername("jmartinez");
        assertThat(preferences.getUsername()).isEqualTo("jmartinez");
    }

    @Test
    public void should_set_notification() {
        preferences.setNotificationEnabled(true);
        assertThat(preferences.hasNotificationEnabled()).isTrue();
    }

    @Test
    public void should_match_defaults() {
        assertThat(preferences.getUsername()).isNull();
        assertThat(preferences.hasNotificationEnabled()).isFalse();
    }
}
```

这显然只是一个简单的例子。有时你会有更复杂的需求，比如将一个对象序列化为 JSON 格式，并存储到 `SharedPreferences` 中，或你的包装类中会封装更多的逻辑特性（每个用户对应一个 `SharedPreferences`，存储多个对象，等）。无论如何，测试你的 `SharedPreferences` 都不应该被低估或忽视。

## 征服数据库升级

维护 SQLite 数据库十分困难。然而，数据库会随着应用更新而变化，保证数据库正常迁移是强制性任务。如果你不能做到，将会导致应用崩溃和用户流失...这是不可接受的！

如下单元测试基于之前同事 [Thibaut](https://twitter.com/fredszaq) 的工作成果。思路是比较新创建的数据库和更新后数据库架构。如果是创建新数据库，只会调用 `SQLiteOpenHelper` 中的 `onCreate` 方法；如果是更新数据库，则会先得到数据库的首个版本（假设显示版本号是1）并调用 `onUpgrade` 方法。通过比较，我们可以确认升级脚本正常工作并给出一个相同的全新数据库。

上代码。首先我们需要添加一个 SQLite JDBC 驱动的依赖：

```gradle
testCompile 'org.xerial:sqlite-jdbc:3.8.10.1'
testCompile 'commons-io:commons-io:1.3.2'
```

如你所见，我还添加了 commons-io 来简化文件操作。接着，是单元测试：

```java
@RunWith(RobolectricTestRunner.class)
@Config(manifest = Config.NONE)
public final class MigrationTest {

    private File newFile;
    private File upgradedFile;

    @Before
    public void setup() throws IOException {
        File baseDir = new File("build/tmp/migration");
        newFile = new File(baseDir, "new.db");
        upgradedFile = new File(baseDir, "upgraded.db");
        File firstDbFile = new File("src/test/resources/origin.db");
        FileUtils.copyFile(firstDbFile, upgradedFile);
    }

    @Test
    public void upgrade_should_be_the_same_as_create() throws Exception {
        Context context = RuntimeEnvironment.application;
        DatabaseOpenHelper helper = new DatabaseOpenHelper(context);

        SQLiteDatabase newDb = SQLiteDatabase.openOrCreateDatabase(newFile, null);
        SQLiteDatabase upgradedDb = SQLiteDatabase.openDatabase(
            upgradedFile.getAbsolutePath(),
            null,
            SQLiteDatabase.OPEN_READWRITE
        );

        helper.onCreate(newDb);
        helper.onUpgrade(upgradedDb, 1, DatabaseOpenHelper.DATABASE_VERSION);

        Set<String> newSchema = extractSchema(newDbFile.getAbsolutePath());
        Set<String> upgradedSchema = extractSchema(upgradedDbFile.getAbsolutePath());

        assertThat(upgradedSchema).isEqualTo(newSchema);
    }

    private Set<String> extractSchema(String url) throws Exception {
        Connection conn = null;

        final Set<String> schema = new TreeSet<>();
        ResultSet tables = null;
        ResultSet columns = null

        try {
            conn = DriverManager.getConnection("jdbc:sqlite:" + url);

            tables = conn.getMetaData().getTables(null, null, null, null);
            while (tables.next()) {

            String tableName = tables.getString("TABLE_NAME");
            String tableType = tables.getString("TABLE_TYPE");
            schema.add(tableType + " " + tableName);

            columns = conn.getMetaData().getColumns(null, null, tableName, null);
                while (columns.next()) {

                  String columnName = columns.getString("COLUMN_NAME");
                  String columnType = columns.getString("TYPE_NAME");
                  String columnNullable = columns.getString("IS_NULLABLE");
                  String columnDefault = columns.getString("COLUMN_DEF");
                  schema.add("TABLE " + tableName +
                        " COLUMN " + columnName + " " + columnType +
                        " NULLABLE=" + columnNullable +
                        " DEFAULT=" + columnDefault);
                }
            }

            return schema;
        } finally {
            closeQuietly(tables);
            closeQuietly(columns);
            closeQuietly(conn);
        }
    }
}
```

使用的方法简洁明了。对于每个数据库：

1. 遍历每一个表
2. 每一个表都用一个字符串代表
3. 遍历表中的每一列
4. 每一列都用一个字符串代表

这些字符串代表了数据库的架构。最后，我们比较两个架构是否相同。

这只是一个例子，但该架构可以被扩展因为 API 中提供了更多可用的条目。你可以在 [Metadata](https://docs.oracle.com/javase/7/docs/api/java/sql/DatabaseMetaData.html) 文档中查看那些是可用的。举个栗子，你还可以比较引用和索引。再次强调，适合你应用的才是最好的。

数据库迁移非常重要，并且经常是出现 bug 的地方。此单元测试可以帮你的迁移脚本正常工作，然后你就可以安全升级啦。

## 结论

这些单元测试只是示例，我希望你能通过本文得到更多东西。对持续分发，数据库安全迁移，权限控制和 SharedPreferences 有效验证有很大的帮助。









