git fetch upstream master
git checkout master
git merge upstream/master
set input =
set /p input=Please input new branch name:
echo Your new branch name is:%input%
git branch %input%
git checkout %input%
echo new branch created
git push origin %input%