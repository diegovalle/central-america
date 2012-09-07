hom.ca <- read.csv("data/UNhomicides.csv")

p <- ggplot(hom.ca, aes(Year, Rate, group = Country.or.Area,
                   color = Country.or.Area)) +
  geom_line() +
  xlim(1995, 2014) +
  opts(title = "Homicide Rates in Central America")
direct.label(p, "last.bumpup")
ggsave("graphs/hom-ca.png", dpi = 100,
       width = 8, height = 5)

hom.ca <- subset(hom.ca, Year >= 2000)
hom.ca <- ddply(hom.ca, .(Country.or.Area), transform,
      per = Rate / Rate[length(Rate)])

p <- ggplot(hom.ca, aes(Year, per, group = Country.or.Area,
                        color = Country.or.Area)) +
                          geom_line() +
                          scale_y_continuous(labels = percent) +
                          xlim(1995, 2014) +
                          ylab("homicide rate as a percentage of that in 2000") +
                          opts(title = "Homicide Rates in Central America as a Percentage of those in 2000")
direct.label(p, "last.bumpup")
ggsave("graphs/hom-ca-percentage.png", dpi = 100,
       width = 8, height = 5)
