library("archdata")
library("dplyr")
library("tidyr")
library("ggplot2") # dev version
library("scales")

data(EWBurials)
ew <- EWBurials

str(ew)
summary(ew)
head(ew)

# looking for % of grave with good per sex and age.
ew2 <- group_by(ew, Age, Sex, Group) %>%
  mutate(Goods = ifelse(Goods == "Present", 1, 0)) %>%
  summarise(sum_goods = sum(Goods),
            cnt = n(),
            pcnt = sum_goods/cnt) %>%
  ungroup() %>%
  tidyr::complete(Age, Sex, Group, fill = list(pcnt = 0))


ggplot(ew2, aes(x = Age, y = pcnt, group = Sex, fill = Sex)) + 
  geom_bar(stat = "identity", position = "dodge")

group_names <- c(`1` = " 2000 - 1200 BCE", `2` = " CE 200 - 500")

ggplot(ew2, aes(x = Age, y = pcnt, group = Sex, fill = Sex)) + 
  geom_bar(stat = "identity", position = "dodge") +
  geom_hline(yintercept = 0, color = "gray70") +
  theme_bw() +
  scale_fill_manual(values = c("darkgoldenrod2", "slategrey")) +
  scale_y_continuous(labels = scales::percent) +
  labs(title="Percent of Grave Goods by Age, Sex, and Temporal Group",
       subtitle="Ernest Witte site, Austin County, Texas",
       caption="Data: Hall,G.D. (1981)",
       y = "Grave Good Presence") +
  facet_grid(Group~., labeller = as_labeller(group_names)) +
  theme(
    strip.background = element_rect(colour = "white", fill = "white"),
    strip.text.y = element_text(colour = "black", size = 10, face = "bold", 
                                family = "Trebuchet MS"),
    panel.border = element_rect(color = "gray90"),
    axis.text.x = element_text(angle = 0, size = 10, family = "Trebuchet MS"),
    axis.text.y = element_text(size = 9, family = "Trebuchet MS"),
    axis.title.y = element_text(size = 11, family = "Trebuchet MS"),
    axis.title.x = element_blank(),
    plot.caption = element_text(size = 10, hjust = 0, margin=margin(t=10), 
                                family = "Trebuchet MS"),
    plot.title=element_text(family="TrebuchetMS-Bold"),
    plot.subtitle=element_text(family="TrebuchetMS-Italic"),
    panel.grid.major.x = element_blank(), 
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    legend.position = c(0.1, 0.85),
    panel.spacing = unit(1, "lines")
  )

# ggsave("Witte_cemetery_grace_good_pcnt.png")
