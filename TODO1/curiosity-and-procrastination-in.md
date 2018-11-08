[Reinforcement learning](https://en.wikipedia.org/wiki/Reinforcement_learning) (RL) is one of the most actively pursued research techniques of machine learning, in which an artificial agent receives a positive reward when it does something right, and negative reward otherwise. This [carrot-and-stick](https://en.wikipedia.org/wiki/Carrot_and_stick) approach is simple and universal, and allowed DeepMind to teach the [DQN](https://deepmind.com/research/dqn/) algorithm to play vintage Atari games and [AlphaGoZero](https://deepmind.com/blog/alphago-zero-learning-scratch/) to play the ancient game of Go. This is also how OpenAI taught its [OpenAI-Five](https://blog.openai.com/openai-five/) algorithm to play the modern video game Dota, and how Google taught robotic arms to [grasp new objects](https://ai.googleblog.com/2018/06/scalable-deep-reinforcement-learning.html). However, despite the successes of RL, there are many challenges to making it an effective technique.  
  
Standard RL algorithms [struggle](https://pathak22.github.io/noreward-rl/) with environments where feedback to the agent is sparse — crucially, such environments are common in the real world. As an example, imagine trying to learn how to find your favorite cheese in a large maze-like supermarket. You search and search but the cheese section is nowhere to be found. If at every step you receive no “carrot” and no “stick”, there’s no way to tell if you are headed in the right direction or not. In the absence of rewards, what is to stop you from wandering around in circles? Nothing, except perhaps your curiosity, which motivates you go into a product section that looks unfamiliar to you in pursuit of your sought-after cheese.  
  
In “[Episodic Curiosity through Reachability](https://arxiv.org/abs/1810.02274)” — the result of a collaboration between the [Google Brain team](https://ai.google/research/teams/brain), [DeepMind](https://deepmind.com/) and [ETH Zürich](https://www.ethz.ch/en.html) — we propose a novel episodic memory-based model of granting RL rewards, akin to curiosity, which leads to exploring the environment. Since we want the agent not only to explore the environment but also to solve the original task, we add a reward bonus provided by our model to the original sparse task reward. The combined reward is not sparse anymore which allows standard RL algorithms to learn from it. Thus, our curiosity method expands the set of tasks which are solvable with RL.  

[![](https://3.bp.blogspot.com/-wwV_MTT8NpI/W89_jWW2FjI/AAAAAAAADas/n8Yh34UlrhIHSVW5owHNqOEq52r1Pyv9gCLcBGAs/s640/image3.png)](https://3.bp.blogspot.com/-wwV_MTT8NpI/W89_jWW2FjI/AAAAAAAADas/n8Yh34UlrhIHSVW5owHNqOEq52r1Pyv9gCLcBGAs/s1600/image3.png)

Episodic Curiosity through Reachability: Observations are added to memory, reward is computed based on how far the current observation is from the most similar observation in memory. The agent receives more reward for seeing observations which are not yet represented in memory.

The key idea of our method is to store the agent's observations of the environment in an episodic memory, while also rewarding the agent for reaching observations not yet represented in memory. Being “not in memory” is the definition of novelty in our method — seeking such observations means seeking the unfamiliar. Such a drive to seek the unfamiliar will lead the artificial agent to new locations, thus keeping it from wandering in circles and ultimately help it stumble on the goal. As we will discuss later, our formulation can save the agent from undesired behaviours which some other formulations are prone to. Much to our surprise, those behaviours bear some similarity to what a layperson would call “procrastination”.  
  
**Previous Curiosity Formulations**  
While there have been many attempts to formulate curiosity in the past\[1\]\[2\]\[3\]\[4\], in this post we  focus on one natural and very popular approach: curiosity through prediction-based surprise, explored in the recent paper “[Curiosity-driven Exploration by Self-supervised Prediction](https://pathak22.github.io/noreward-rl/)” (commonly referred to as the ICM method). To illustrate how surprise leads to curiosity, again consider our analogy of looking for cheese in a supermarket.  

[![](https://3.bp.blogspot.com/-mmkoFCNHjZo/W9ChEkHbAoI/AAAAAAAADb4/iFJYE7IRKRIg-CTxSa-ndRvmHHq5EfDUgCLcBGAs/s400/image1.jpg)](https://3.bp.blogspot.com/-mmkoFCNHjZo/W9ChEkHbAoI/AAAAAAAADb4/iFJYE7IRKRIg-CTxSa-ndRvmHHq5EfDUgCLcBGAs/s1600/image1.jpg)

Illustration © [Indira Pasko](https://www.behance.net/gallery/71741137/Illustration-for-an-article-in-aigoogleblogcom), used under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en_US) license.

As you wander throughout the market, you try to predict the future (_“Now I’m in the meat section, so I think the section around the corner is the fish section — those are usually adjacent in this supermarket chain”_). If your prediction is wrong, you are surprised (_“No, it’s actually the vegetables section. I didn’t expect that!”_) and thus rewarded. This makes you more motivated to look around the corner in the future, exploring new locations just to see if your expectations about them meet the reality (and, hopefully, stumble upon the cheese).  
  
Similarly, the ICM method builds a predictive model of the dynamics of the world and gives the agent rewards when the model fails to make good predictions — a marker of surprise or novelty. Note that exploring unvisited locations is not directly a part of the ICM curiosity formulation. For the ICM method, visiting them is only a way to obtain more “surprise” and thus maximize overall rewards. As it turns out, in some environments there could be other ways to inflict self-surprise, leading to unforeseen results.  

[![](https://4.bp.blogspot.com/-1-g1VrGbUpY/W8-MI2HcI1I/AAAAAAAADbg/O65BaNTc6fEcJjSouw-QG1g7JkeIXpGLACLcBGAs/s1600/image5.gif)](https://4.bp.blogspot.com/-1-g1VrGbUpY/W8-MI2HcI1I/AAAAAAAADbg/O65BaNTc6fEcJjSouw-QG1g7JkeIXpGLACLcBGAs/s1600/image5.gif)

Agent imbued with surprise-based curiosity gets stuck when it encounters TV. GIF adopted from a video by © [Deepak Pathak](https://youtu.be/C3yKgCzvE_E), used under [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/) license.

**The Dangers of “Procrastination”**  
In "[Large-Scale Study of Curiosity-Driven Learning](https://pathak22.github.io/large-scale-curiosity/resources/largeScaleCuriosity2018.pdf)", the authors of the ICM method along with researchers from [OpenAI](https://openai.com/) show a hidden danger of surprise maximization: agents can learn to indulge procrastination-like behaviour instead of doing something useful for the task at hand. To see why, consider a common thought experiment the authors call the “noisy TV problem”, in which an agent is put into a maze and tasked with finding a highly rewarding item (akin to “cheese” in our previous supermarket example). The environment also contains a TV for which the agent has the remote control. There is a limited number of channels (each with a distinct show) and every press on the remote control switches to a random channel. How would an agent perform in such an environment?  
  
For the surprise-based curiosity formulation, changing channels would result in a large reward, as each change is unpredictable and surprising. Crucially, even after cycling through all the available channels, the random channel selection ensures every new change will still be surprising — the agent is making predictions about what will be on the TV after a channel change, and will very likely be wrong, leading to surprise. Importantly, even if the agent has already seen every show on every channel, the change is still unpredictable. Because of this, the agent imbued with surprise-based curiosity would eventually stay in front of the TV forever instead of searching for a highly rewarding item — akin to procrastination. So, what would be a definition of curiosity which does not lead to such behaviour?  
  
**Episodic Curiosity**  
In “[Episodic Curiosity through Reachability](https://arxiv.org/abs/1810.02274)”, we explore an episodic memory-based curiosity model that turns out to be less prone to “self-indulging” instant gratification. Why so? Using our example above, after changing channels for a while, all of the shows will end up in memory. Thus, the TV won’t be so attractive anymore: even if the order of shows appearing on the screen is random and unpredictable, all those shows are already in memory! This is the main difference to the surprise-based methods: our method doesn’t even try to make bets about the future which could be hard (or even impossible) to predict. Instead, the agent examines the past to know if it has seen observations _similar_ to the current one. Thus our agent won’t be drawn that much to the instant gratification provided by the noisy TV. It will have to go and explore the world outside of the TV to get more reward.  
  
But how do we decide whether the agent is seeing the same thing as an existing memory? Checking for an exact match could be meaningless: in a realistic environment, the agent rarely sees exactly the same thing twice. For example, even if the agent returned to exactly the same room, it would still see this room under a different angle compared to its memories.  
  
Instead of checking for an exact match in memory, we use a [deep neural network](https://en.wikipedia.org/wiki/Deep_learning) that is trained to measure how similar two experiences are. To train this network, we have it guess whether two observations were experienced close together in time, or far apart in time. Temporal proximity is a good proxy for whether two experiences should be judged to be part of the same experience. This training leads to a general concept of novelty via reachability which is illustrated below.  

[![](https://3.bp.blogspot.com/-7X2mG9KkAwA/W8-AwA02tDI/AAAAAAAADa8/ENoWNgeYDwwGDbbZV-cPGgJtwsTMeQc0wCLcBGAs/s640/image6.png)](https://3.bp.blogspot.com/-7X2mG9KkAwA/W8-AwA02tDI/AAAAAAAADa8/ENoWNgeYDwwGDbbZV-cPGgJtwsTMeQc0wCLcBGAs/s1600/image6.png)

Graph of reachabilities would determine novelty. In practice, this graph is not available — so we train a neural network approximator to estimate a number of steps between observations.

**Experimental Results**  
To compare the performance of different approaches to curiosity, we tested them in two visually rich 3D environments: [ViZDoom](https://arxiv.org/abs/1605.02097) and [DMLab](https://arxiv.org/abs/1612.03801). In those environments, the agent was tasked with various problems like searching for a goal in a maze or collecting good and avoiding bad objects. The DMLab environment happens to provide the agent with a laser-like science fiction gadget. The standard setting in the previous work on DMLab was to equip the agent with this gadget for all tasks, and if the agent does not need a gadget for a particular task, it is free not to use it. Interestingly, similar to the noisy TV experiment described above, the surprise-based ICM method actually uses this gadget a lot even when it is useless for the task at hand! When tasked with searching for a high-rewarding item in the maze, it instead prefers to spend time tagging walls because this yields a lot of “surprise” reward. Theoretically, predicting the result of tagging should be possible, but in practice is too hard as it apparently requires a deeper knowledge of physics than is available to a standard agent.  

[![](https://1.bp.blogspot.com/-pn6yWeacipw/W9ChvSGMPtI/AAAAAAAADcA/1yJQHc7dz1AOiXTm8OyBW1JDI3_r40vbgCLcBGAs/s1600/image7.gif)](https://1.bp.blogspot.com/-pn6yWeacipw/W9ChvSGMPtI/AAAAAAAADcA/1yJQHc7dz1AOiXTm8OyBW1JDI3_r40vbgCLcBGAs/s1600/image7.gif)

Surprise-based ICM method is persistently tagging the wall instead of exploring the maze.

Our method instead learns reasonable exploration behaviour under the same conditions. This is because it does not try to predict the result of its actions, but rather seeks observations which are “harder” to achieve from those already in the episodic memory. In other words, the agent implicitly pursues goals which require more effort to reach from memory than just a single tagging action.  

[![](https://3.bp.blogspot.com/-gqgK7Dd2jUw/W9CiFgzQmxI/AAAAAAAADcI/EcUCBL9w2Cc57jPFzHcOd70OX8yUzAuEQCLcBGAs/s1600/image6.gif)](https://3.bp.blogspot.com/-gqgK7Dd2jUw/W9CiFgzQmxI/AAAAAAAADcI/EcUCBL9w2Cc57jPFzHcOd70OX8yUzAuEQCLcBGAs/s1600/image6.gif)

Our method shows reasonable exploration.

It is interesting to see that our approach to granting reward penalizes an agent running in circles. This is because after completing the first circle the agent does not encounter new observations other than those in memory, and thus receives no reward:  

[![](https://3.bp.blogspot.com/-s_QMz-9Hwfc/W89-GjKp7xI/AAAAAAAADaU/HRe_JVE2tyIOyJhFp8UjbtvTbtLxK6KqQCLcBGAs/s640/image8.gif)](https://3.bp.blogspot.com/-s_QMz-9Hwfc/W89-GjKp7xI/AAAAAAAADaU/HRe_JVE2tyIOyJhFp8UjbtvTbtLxK6KqQCLcBGAs/s1600/image8.gif)

Our reward visualization: red means negative reward, green means positive reward. Left to right: map with rewards, map with locations currently in memory, first-person view.

At the same time, our method favors good exploration behavior:  

[![](https://2.bp.blogspot.com/-vYTrGZe07E8/W9CinK0dkyI/AAAAAAAADcU/rRYZw30k_0IQ5SrOzamcaKdsXk4JDhutwCLcBGAs/s640/image2.gif)](https://2.bp.blogspot.com/-vYTrGZe07E8/W9CinK0dkyI/AAAAAAAADcU/rRYZw30k_0IQ5SrOzamcaKdsXk4JDhutwCLcBGAs/s1600/image2.gif)

Our reward visualization: red means negative reward, green means positive reward. Left to right: map with rewards, map with locations currently in memory, first-person view.

We hope that our work will help lead to a new wave of exploration methods, going beyond surprise and learning more intelligent exploration behaviours. For an in-depth analysis of our method, please take a look at the preprint of our [research paper](https://arxiv.org/abs/1810.02274).  
  
**Acknowledgements:**  
_This project is a result of a collaboration between the Google Brain team, DeepMind and ETH Zürich. The core team includes Nikolay Savinov, Anton Raichuk, Raphaël Marinier, Damien Vincent, Marc Pollefeys, Timothy Lillicrap and Sylvain Gelly. We would like to thank Olivier Pietquin, Carlos Riquelme, Charles Blundell and Sergey Levine for the discussions about the paper. We are grateful to Indira Pasko for the help with illustrations._  
  
**References:**  
\[1\] "[Count-Based Exploration with Neural Density Models](https://arxiv.org/abs/1703.01310)", _Georg Ostrovski, Marc G. Bellemare, Aaron van den Oord, Remi Munos_  
\[2\] "[#Exploration: A Study of Count-Based Exploration for Deep Reinforcement Learning](https://arxiv.org/abs/1611.04717)", _Haoran Tang, Rein Houthooft, Davis Foote, Adam Stooke, Xi Chen, Yan Duan, John Schulman, Filip De Turck, Pieter Abbeel_  
\[3\] "[Unsupervised Learning of Goal Spaces for Intrinsically Motivated Goal Exploration](https://arxiv.org/abs/1803.00781)", _Alexandre Péré, Sébastien Forestier, Olivier Sigaud, Pierre-Yves Oudeyer_  
\[4\] "[VIME: Variational Information Maximizing Exploration](https://arxiv.org/abs/1605.09674)", _Rein Houthooft, Xi Chen, Yan Duan, John Schulman, Filip De Turck, Pieter Abbeel_
