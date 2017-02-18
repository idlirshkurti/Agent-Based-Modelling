# Get a vector (tot_wealth) of the total accumulated wealth of all agents combined
# from time t = 0 to time t = 100
tot_wealth <- NULL
for (j in 1:101){
	tot_wealth[j] <- sum(wealth[,j])
}

# Create a final dataset with the x and y coords of objects and agents together
final_df <- data.frame(x = c(dfx[,102],x_obj) , y = c(dfy[,102], y_obj), z = z)

# Final positions of the agents
final_plot <- ggplot(data = data.frame(x = dfx[,102], y = dfy[,102]), aes(x = x, y = y)) 
final_plot <- final_plot + geom_point(shape=1) 
final_plot <- final_plot + xlim(-3, 3) + ylim(-3, 3)
final_plot <- final_plot + labs(x = "Final x position",  y = "Final y position", 
	title = "Final Positions of Agents")
pdf("Final Agents.pdf", 7, 5)
plot(final_plot)
dev.off()

# Final positions of the agents and objects
final <- ggplot(data = final_df, aes(x = x, y = y)) 
final <- final + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
final <- final + xlim(-10, 10) + ylim(-10, 10)
final <- final + labs(x = "Final x position",  y = "Final y position", 
	title = " Final Positions of Objects and Agents")
final <- final + theme(plot.title = element_text(size = rel(2)))
pdf("Final Agents-Objects.pdf", 7, 5)
plot(final)
dev.off()

# (zoomed-in) Final positions of the agents and objects
final_zoom <- ggplot(data = final_df, aes(x = x, y = y)) 
final_zoom <- final_zoom + geom_point(size=2, aes(color=factor(z), shape=factor(z))) + 
					 theme(legend.title=element_blank()) 
final_zoom <- final_zoom + xlim(-2, 2) + ylim(-2, 2)
final_zoom <- final_zoom + labs(x = "Final x position",  y = "Final y position", 
	title = " Final Positions of Objects and Agents")
final_zoom <- final_zoom + theme(plot.title = element_text(size = rel(2)))
pdf("Final Agents-Objects(zoomed).pdf", 7, 5)
plot(final_zoom)
dev.off()

# Accumulated wealth plot over time
pl1 <- ggplot(as.data.frame(tot_wealth), aes(x = c(1:101) , y = tot_wealth))
pl1 <- pl1 + labs(x = "Time",  y = "Wealth", 
	title = "Accumulated Wealth Over Time")
pl1 <- pl1 + geom_line(colour = "deepskyblue4")
pl1 <- pl1 +  theme(plot.title = element_text(size = rel(2)))
pdf("Accumulated Wealth.pdf", 7, 5)
plot(pl1)
dev.off()
