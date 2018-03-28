complaints$Date_received <- as.Date(complaints$Date_received, "%m/%d/%Y")
complaints$Year <- as.factor(year(complaints$Date_received))
ggplot(complaints, aes(Year)) + geom_bar(fill = "blue") + ggtitle("Complaints Year-wise") + xlab("Year") + ylab("Count of Complaints")
