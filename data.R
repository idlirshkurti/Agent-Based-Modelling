# ----------------------------------------------------------------- #
# -------------------- AGENT BASED MODELLING ---------------------- #
# ----------------------------------------------------------------- #

# Packages required for this code to run
packages <- c("ggplot2", "FNN", "utils")
lapply(packages, require, character.only = TRUE)

n <- 1000
a <- 0.01
i <- c(1:n) # order of agents

# Define the x-y locations of the agents and the objects
x <- runif(n,0,1)
y <- runif(n,0,1)
x_obj <- runif(n,-10,10); y_obj <- runif(n,-10,10)
objects <- data.frame(x = x_obj, y = y_obj)

nn <- 5 # The number of nearest neighbours used in the algorithm

# Pre-define a data frame with the initial starting points of each agent
# at time t = 0 and positions = 0 for the remaining time points. These
# positions will be changed in the loop below. 
dfx <- as.data.frame(matrix(0, n, 102))
dfy <- as.data.frame(matrix(0, n, 102))
dfx[,c(1, 2)] <- cbind(i, x)
dfy[,c(1, 2)] <- cbind(i, y)

# Initial empty data frame which will later contain the accumulated wealth of each agent
wealth <- as.data.frame(matrix(0, n, 101))

# Dimension names for the data frames 
names <- NULL
for(t in 1:102){
	if(t==1){
		names[t] <- as.character("Individual")
	}else{
names[t]<-as.character(paste("time =", t - 2))
}}

dimnames(dfx)[[2]] <- names
dimnames(dfy)[[2]] <- names
dimnames(wealth)[[2]] <- names[-1]

# Initial positions of the agents
init_plot <- ggplot(data = data.frame(x = dfx[,2], y = dfy[,2]), aes(x = x, y = y)) 
init_plot <- init_plot + geom_point(shape=1) 
init_plot <- init_plot + xlim(0, 1) + ylim(0, 1)
init_plot <- init_plot + labs(x = "Final x position",  y = "Final y position", 
	     title = "Initial Positions of Agents")
pdf("Initial Agents.pdf", 7, 5)
plot(init_plot)
dev.off()

# Initial positions of the objects
init_obj <- ggplot(data = data.frame(x = x_obj, y = y_obj), aes(x = x, y = y)) 
init_obj <- init_obj + geom_point(shape=1) 
init_obj <- init_obj + xlim(-10, 10) + ylim(-10, 10)
init_obj <- init_obj + labs(x = "Final x position",  y = "Final y position", 
	    title = "Initial Positions of Objects")
pdf("Initial Objects.pdf", 7, 5)
plot(init_obj)
dev.off()

# Create a factor vector 'z' of length 2000 with levels "Agents" and "Objects"
z <- as.factor(c(rep(1,n),rep(2,n)))
levels(z) <- c("Agents", "Objects")

# Create an initial dataset with the x and y coords of objects and agents together
initial_df <- data.frame(x = c(dfx[,2],x_obj) , y = c(dfy[,2], y_obj), z = z)

# Initial positions of the agents and objects
initial <- ggplot(data = initial_df, aes(x = x, y = y)) 
initial <- initial + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
initial <- initial + xlim(-10, 10) + ylim(-10, 10)
initial <- initial + labs(x = "X - position",  y = "Y - position", 
	title = " Initial Positions of Objects and Agents")
initial <- initial + theme(plot.title = element_text(size = rel(2)))
pdf("Initial Agents-Objects.pdf", 7, 5)
plot(initial)
dev.off()

# (zoomed-in) Initial positions of the agents and objects
initial_zoom <- ggplot(data = initial_df, aes(x = x, y = y)) 
initial_zoom <- initial_zoom + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
initial_zoom <- initial_zoom + xlim(-1, 2) + ylim(-1, 2)
initial_zoom <- initial_zoom + labs(x = "X - position",  y = "Y - position", 
	        title = " Initial Positions of Objects and Agents")
initial_zoom <- initial_zoom + theme(plot.title = element_text(size = rel(2)))
pdf("Initial Agents-Objects(zoomed).pdf", 7, 5)
plot(initial_zoom)
dev.off()
