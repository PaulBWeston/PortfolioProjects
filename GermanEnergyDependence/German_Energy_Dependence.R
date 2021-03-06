#German Energy Dependence
#By Paul Weston


#R Setup
library(dplyr)
library(tidyr)
library(ggplot2)

#Importing Data
data <- "/Users/paul/Documents/DataProjects/European Energy Dependence/owid-energy-data.csv"

energy <-read.csv(data)

View(energy)

#Data Manipulation
#Create data frames to only look at European countries

#below is a vector that contains the ISO codes for all European countries
euro_countries <- c("AUT", "BEL", "BGR", "HRV", "CYP", "CZE", "DNK", "EST", "FIN", "FRA", "DEU", "GRC", "HUN", "IRL", "ITA", "LVA", "LTU", "LUX", "MLT", "NLD", "POL", "PRT", "ROU", "SVK", "SVN", 
  "ESP", "SWE", "GBR", "ALB", "AND", "ARM", "BLR", "BIH", "FRO", "GEO", "GIB", "ISL", "IMN", "XKX", "LIE", "MKD", "MDA", "MCO", "MNE", "NOR", "SMR", "SRB", "CHE", "TUR", "UKR", "GBR", "VAT")

euro_energy <- filter(energy, iso_code %in% euro_countries)

View(euro_energy)

#New data frame for just gas in Europe
eurogas <- euro_energy %>%
  select(country, year, gas_electricity, gas_share_energy, gas_consumption, gas_production)

#Add net gas production variable to euro_gas
attach(eurogas)
eurogas$netgas_production <- gas_production - gas_consumption
detach(eurogas)
View(eurogas)

#Analysis
#Create Germany breakdown by energy source as Portion of total energy
germany_breakdown <-euro_energy %>%
  filter(country == "Germany") %>%
  select(year, biofuel_share_energy, coal_share_energy, gas_share_energy, hydro_share_energy, 
         nuclear_share_energy, oil_share_energy, other_renewables_share_energy, solar_share_energy, wind_share_energy)
View(germany_breakdown)

#Confiriming the breakdown adds to 100%
attach(germany_breakdown)
germany_breakdown$sum <- biofuel_share_energy + coal_share_energy + gas_share_energy + hydro_share_energy +
  nuclear_share_energy + oil_share_energy + other_renewables_share_energy +solar_share_energy + wind_share_energy
detach(germany_breakdown)

#2019 energy breakdown for germany
euro_energy %>%
  select(country, year, biofuel_share_energy, coal_share_energy, gas_share_energy, hydro_share_energy, 
         nuclear_share_energy, oil_share_energy, other_renewables_share_energy, solar_share_energy, wind_share_energy) %>%
  filter(country == "Germany", year == 2019)



#Production and Consumption in Germany
#We are only given production and consumption variables for Oil, Gas, and Coal
germany_fossilfuels <- euro_energy %>%
  filter(country == "Germany") %>%
  select(year, gas_production, gas_consumption, oil_production, oil_consumption, coal_production, coal_consumption)
View(germany_fossilfuels)

summary(germany_fossilfuels)


#2019 netgas across europe
eurogas %>% filter(year == 2019) %>% 
  select(year, country, netgas_production)

#creating a new long data version of germany_breakdown for upcoming visualizations
long_germany_breakdown <- germany_breakdown%>%
  filter(year >= 1965) %>% pivot_longer(.,-year, names_to = "Variable", values_to = "Value")
View(long_germany_breakdown)

#export long_germany_breakdown for Tableau Dashboard
write.csv(long_germany_breakdown, "/Users/paul/Documents/DataProjects/European Energy Dependence/long_germany_breakdown.csv", row.names = FALSE)

#Data Visualization
#German Energy Sources By Year - Stacked Bar Chart
germany_breakdown %>%
  filter(year >= 1965) %>% pivot_longer(.,-year, names_to = "Variable", values_to = "Value")

breakdown_stacked <- germany_breakdown %>%
  filter(year >= 1965) %>% 
  pivot_longer(.,-year, names_to = "Variable", values_to = "Value") %>%
  mutate(Variable = factor(Variable, levels = c("oil_share_energy", "gas_share_energy", "coal_share_energy", "biofuel_share_energy",
                                                "nuclear_share_energy", "wind_share_energy", "solar_share_energy", "hydro_share_energy", "other_renewables_share_energy"))) %>%
  ggplot(aes(x = year, y = Value, fill = Variable))+
  geom_bar(stat = "identity", position = "fill", width = 1)+
  scale_x_continuous(breaks = seq(from = 1965, to = 2020, by = 5))+
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.05))) +
  labs(title = "Energy Sources by Year in Germany", subtitle = "(% Proportional to Total Energy Consumed)", fill = "Energy Source") +
  xlab("Year") + ylab("") +
  scale_fill_discrete(labels = c("Oil", "Gas", "Coal", "Biofuel", "Nuclear", "Wind", "Solar", "Hydro", "Other Renewables")) +
  theme(legend.position ="right") +
  theme(plot.title=element_text(face = "bold", color="black")) +
  theme(plot.subtitle=element_text(face = "bold", color="dim grey"))
  theme(text = element_text(family = "Helvetica"))
#With Annotations
breakdown_stacked +
  annotate("text", x = 2015, y = .3, size = 4,
         label = "Coal") +
  annotate("text", x = 2015, y = .55, size = 4,
           label = "Gas") +
  annotate("text", x = 2015, y = .8, size = 4,
         label = "Oil") +
  annotate("text", x = 2010, y = .1, size = 4,
           label = "Renewables")

print(breakdown_stacked)

# German Energy Sources of 2019 - Pie Chart
# To remove clutter on our pie chart we combine renewables into already existing renewables_share_energy variable
germany_simplebreakdown <-euro_energy %>%
  filter(country == "Germany") %>%
  select(year, gas_share_energy, coal_share_energy, oil_share_energy, renewables_share_energy)

germany_simplebreakdown %>%
  filter(year == 2019) %>% 
  pivot_longer(.,-year, names_to = "Variable", values_to = "Value") %>%
  ggplot(aes(x="", y=Value, fill  = Variable)) +
  geom_col(color = "black") +
  geom_text(aes(label = paste(Value,"%", sep = "", collapse = NULL)), position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y") +
  labs(title = "Energy Breakdown in Germany By Source (2019)", fill = "Energy Source") +
  scale_fill_manual(values = c("darkgoldenrod", "chocolate2", "darkorange4", "darkolivegreen4"),
                    labels = c("Coal", "Gas", "Oil", "Renewables")) +
  theme(plot.title = element_text(face = "bold", color = "black"),
        text = element_text(family = "Helvetica")) +
  xlab("") + ylab("")

#Gas as a percent of total energy consumption
ggplot(filter(euro_energy, country == "Germany", year >= 1960)) +
  geom_line(mapping = aes(x = year, y = gas_share_energy), size = 1, color = "red") +
  ggtitle("Gas Share of Total Energy Consumption in Germany", subtitle = "% of Total Energy Consumption") +
  xlab("Year") + ylab("") +
  theme(legend.position ="right") +
  theme(plot.title=element_text(face = "bold", color="black")) +
  theme(plot.subtitle=element_text(face = "bold", color="dim grey")) +
  theme(text = element_text(family = "Helvetica")) +
  annotate("text", x = 2021.7, y = 24.29, size = 3,
           label = "24.29%")

germany_breakdown %>%
  filter(year >= 2015) %>%
  select(year, gas_share_energy)


#Gas production vs consumption in Germany
ggplot(filter(euro_energy, country == "Germany", year >= 1950)) +
  geom_line(mapping = aes(x = year, y = gas_production, color = "Production"), size = 1) +
  geom_line(mapping = aes(x = year, y = gas_consumption, color = "Consumption"), size = 1) +
  scale_color_manual(name = "", values = c("Production" = "darkblue", "Consumption" = "red")) +
  ggtitle("Gas Production V.S. Consumption in Germany", subtitle = "(in terawatt-hours)") +
  xlab("Year") + ylab("") +
  theme(plot.title=element_text(face = "bold", color="black")) +
  theme(plot.subtitle=element_text(face = "bold", color="dimgrey")) +
  theme(legend.position = c(0.2,.8),
        legend.background = element_rect(fill = "white", color = "black"),
        legend.title = element_blank())+
  scale_fill_discrete(guide = guide_legend(reverse=TRUE)) +
  theme(plot.title=element_text(face = "bold", color="black"),
        plot.subtitle=element_text(face = "bold", color="dim grey"),
        text = element_text(family = "Helvetica")) +
  annotate("text", x = 2022.6, y = 886.57, size = 4,
           label = "886.57") +
  annotate("text", x = 2022, y = 53.31, size = 4,
           label = "53.31")

#Coal: Production V.S. Consumption
ggplot(filter(euro_energy, country == "Germany", year >= 1980)) +
  geom_line(mapping = aes(x = year, y = coal_production, color = "Production"), size = 1) +
  geom_line(mapping = aes(x = year, y = coal_consumption, color = "Consumption"), size = 1) +
  scale_color_manual(name = "", values = c("Production" = "darkblue", "Consumption" = "red")) +
  ggtitle("Coal Production V.S. Consumption in Germany", subtitle = "(in terawatt-hours)") +
  xlab("Year") + ylab("") +
  theme(plot.title=element_text(face = "bold", color="black")) +
  theme(plot.subtitle=element_text(face = "bold", color="dimgrey")) +
  theme(legend.position = c(0.2,0.2),
        legend.background = element_rect(fill = "white", color = "black"),
        legend.title = element_blank())+
  scale_fill_discrete(guide = guide_legend(reverse=TRUE)) +
  theme(plot.title=element_text(face = "bold", color="black"),
        plot.subtitle=element_text(face = "bold", color="dim grey"),
        text = element_text(family = "Helvetica"))

#Oil production V.S. consumption
ggplot(filter(euro_energy, country == "Germany", year >= 1950)) +
  geom_line(mapping = aes(x = year, y = oil_production, color = "Production"), size = 1) +
  geom_line(mapping = aes(x = year, y = oil_consumption, color = "Consumption"), size = 1) +
  scale_color_manual(name = "", values = c("Production" = "darkblue", "Consumption" = "red")) +
  ggtitle("Oil Production V.S. Consumption in Germany", subtitle = "(in terawatt-hours)") +
  xlab("Year") + ylab("") +
  theme(plot.title=element_text(face = "bold", color="black")) +
  theme(plot.subtitle=element_text(face = "bold", color="dimgrey")) +
  theme(legend.position = c(0.15,0.8),
        legend.background = element_rect(fill = "white", color = "black"),
        legend.title = element_blank())+
  scale_fill_discrete(guide = guide_legend(reverse=TRUE)) +
  theme(plot.title=element_text(face = "bold", color="black"),
        plot.subtitle=element_text(face = "bold", color="dim grey"),
        text = element_text(family = "Helvetica"))

#looking at final totals for possible annotations
eurogas %>%
  filter(country == "Germany", year == 2019) %>%
  select(year, gas_production, gas_consumption)
  

#Line plot of German net gas production
ggplot(filter(euro_energy, country == "Germany", year >= 1950)) +
  geom_line(mapping = aes(x = year, y = gas_production - gas_consumption, color = "Net Production"), size = 1) +
  scale_color_manual(name = "", values = c("Net Production" = "darkblue")) +
  ggtitle("German Net Gas Production", subtitle = "(in terawatt-hours)") +
  xlab("Year") + ylab("") +
  theme(plot.title=element_text(face = "bold", color="black"),
        plot.subtitle=element_text(face = "bold", color="dimgrey"),
        text = element_text(family = "Helvetica"))

#Quick look at Russian production and consumption of natural gas
ggplot(filter(energy, country == "Russia", year >= 1950)) +
  geom_line(mapping = aes(x = year, y = gas_production, color = "Production"), size = 1) +
  geom_line(mapping = aes(x = year, y = gas_consumption, color = "Consumption"), size = 1) +
  scale_color_manual(name = "", values = c("Production" = "darkblue", "Consumption" = "red")) +
  ggtitle("Russian Gas", subtitle = "Production V.S. Consumption") +
  xlab("Year") + ylab("Gas (terawatt-hours)")

