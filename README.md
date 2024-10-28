# Agent Based Modelling: Simulating Social Dynamics

Agent-based modeling (ABM) is a fascinating approach to understanding complex systems by simulating interactions among individual agents. Through my latest work, documented in [this report](https://github.com/idlirshkurti/Agent-Based-Modelling/blob/master/agent-based-modelling.pdf), I explored how agents, driven by simple rules, can collectively give rise to intricate, large-scale behaviors. Let me walk you through the key insights and methodologies of this project.

### What is Agent-Based Modeling?

Agent-based modeling is a computational framework where individual entities, called agents, follow a set of predefined rules. These agents interact with each other and their environment, creating emergent behaviors that often can't be easily predicted from the rules governing individual agents. This type of modeling is especially useful in fields like economics, sociology, biology, and urban planning, where interactions between components are central to understanding the system as a whole.

### The ABM Approach in My Work

The project I worked on focused on **simulating social dynamics** through agent-based modeling. Specifically, I aimed to replicate how simple decision-making processes at the individual level can aggregate to produce societal phenomena like cooperation, competition, or even conflict.

At the core of this project were **agents** representing individuals in a simulated society. These agents were given simple rules of interaction, such as:
- **Movement** within a grid environment
- **Resource acquisition** or competition for limited resources
- **Cooperative behaviors**, where some agents opted to share resources or cooperate under specific conditions.

The agents in this model operated within a spatial environment, allowing for **local interactions** that are critical in understanding how global patterns emerge from local behaviors.

### Key Components of the Model

In this ABM setup, a few critical elements determined the dynamics of the system:

- **Rules and Decision-Making**: Each agent was governed by simple rules that dictated its behavior based on its immediate surroundings and interactions with other agents. These could include gathering resources, moving towards or away from other agents, and making decisions based on proximity to certain goals or threats.

- **Environment**: The agents existed within a spatial grid, and their behavior could change depending on their position and local interactions. This environmental setup is essential in capturing the realistic constraints and conditions that influence agent behavior.

- **Emergent Properties**: One of the most exciting aspects of ABM is the emergent properties that arise from the individual interactions. In this project, certain unexpected patterns emerged, such as clusters of cooperation or resource competition "hotspots" that arose spontaneously, driven by the agents' individual decisions.

### The Algorithm

The final agent-based algorithm can be broken down into the following steps:

1. Let \\( i \\) represent the \\( i \\)-th agent at time \\( t \\), with \\( i = 1, 2, \dots, 1000 \\) and \\( t = 1, 2, \dots, 100 \\). Randomly locate each agent at coordinates \\( (x_i, y_i) \\), where \\( x_i \sim U(0, 1) \\) and \\( y_i \sim U(0, 1) \\).

2. Randomly locate 1000 objects \\( k_1, k_2, \dots, k_{1000} \\) at coordinates \\( (x_k, y_k) \\), where \\( x_k \sim U(-10, 10) \\) and \\( y_k \sim U(-10, 10) \\).

3. At time \\( t+1 \\), each agent \\( i \\) moves a random distance in both \\( x \\) and \\( y \\) directions:
   $$
   x_{i,\text{new}} = x_{i,t} + d_{i,x}, \quad y_{i,\text{new}} = y_{i,t} + d_{i,y}
   $$
   where \\( d_{i,x} \sim U(-1, 1) \\) and \\( d_{i,y} \sim U(-1, 1) \\).

4. Each agent \\( i \\) identifies the \\( f \\)-closest neighbors and adjusts its position by halving the average distance to them. The new coordinates at time \\( t+1 \\) are:
   $$
   x_{i,t+1} = 0.5(x_{i,\text{new}} + \bar{x}_{f}), \quad y_{i,t+1} = 0.5(y_{i,\text{new}} + \bar{y}_{f})
   $$
   where \\( \bar{x}_f \\) and \\( \bar{y}_f \\) are the average \\( x \\)- and \\( y \\)-coordinates of the \\( f \\)-closest neighbors of agent \\( i \\). Euclidean distance is used to determine these neighbors.

5. Compute the Euclidean distance \\( g(i,k) \\) between each agent \\( i \\) and object \\( k \\):
   $$
   g(i + d, k) = \sqrt{(x_{i,\text{new}} - x_k)^2 + (y_{i,\text{new}} - y_k)^2}
   $$
   If \\( g(i + d, k) < a \\) (where \\( a \\) is a threshold), the wealth of agent \\( i \\) increases:
   $$
   w_{i,t+1} = w_{i,t} + 1
   $$

In this model, the parameters used are \\( f = 5 \\) (5 closest neighbors) and \\( a = 0.01 \\) (distance threshold).
