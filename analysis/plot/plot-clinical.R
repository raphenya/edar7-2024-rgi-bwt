# Reference: https://r-graph-gallery.com/web-dumbell-chart.html

library(dplyr)
library(tidyr)
library(forcats)
library(ggplot2)
library(ggtext)
library(scales)
library(prismatic)

# set path
setwd("/Users/amos/Documents/repos/edar7-2024-rgi-bwt")

# data
df_matches <- 
  tibble(
    team = c("SRR8902844",
        "SRR8902845",
        "SRR8902846",
        "SRR8902847",
        "SRR8902848",
        "SRR8902849",
        "SRR8902850",
        "SRR8902851",
        "SRR8902852",
        "SRR8902853",
        "SRR8902854",
        "SRR8902855",
        "SRR8902856",
        "SRR8902857",
        "SRR8902858",
        "SRR8902859",
        "SRR8902860",
        "SRR8980893",
        "SRR8980894",
        "SRR8980895",
        "SRR8980896",
        "SRR8980897",
        "SRR8980898",
        "SRR8980899",
        "SRR8980900",
        "SRR8980901",
        "SRR8980902",
        "SRR8980903",
        "SRR8980904",
        "SRR8980905",
        "SRR8980906",
        "SRR8980907",
        "SRR8980908",
        "SRR8980909"),
     matches = c(rep(100,34)), # total reads per sample
     won =     c(
                64,
                66,
                65,
                61,
                64,
                60,
                57,
                56,
                61,
                57,
                57,
                63,
                68,
                60,
                58,
                57,
                56,
                49,
                50,
                49,
                50,
                49,
                50,
                49,
                50,
                50,
                50,
                51,
                50,
                50,
                50,
                49,
                49,
                50), # mapped reads per sample (wild)
    lost =    c(
                36,
                34,
                35,
                39,
                36,
                40,
                43,
                44,
                39,
                43,
                43,
                37,
                32,
                40,
                42,
                43,
                44,
                51,
                50,
                51,
                50,
                51,
                50,
                51,
                50,
                50,
                50,
                49,
                50,
                50,
                50,
                51,
                51,
                50) # mapped reads per sample (cannonical)
  ) |> 
  mutate(team = fct_rev(fct_inorder(team))) |> 
  pivot_longer(
    cols = -c(team, matches),
    names_to = "type",
    values_to = "result"
  ) |> 
  mutate(share = result / matches) |> 
  arrange(team, -share) |> 
  mutate(is_smaller = if_else(row_number() == 1, 0, 1), .by = team)

## number of teams for emphasis later
n <- length(unique(df_matches$team)) - 1

# colors

pal_base <- c("#EFAC00", "#28A87D")
pal_dark <- clr_darken(pal_base, .25)

grey_base <- "grey50"
grey_dark <- "grey25"

# theme

theme_set(theme_minimal(base_family = "sans", base_size = 22))
theme_update(
  axis.title = element_blank(),
  axis.text.y = element_text(hjust = 0, color = grey_dark),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank(),
  plot.title = element_textbox_simple(
    size = rel(1.25), face = "plain", lineheight = 1.05, 
    fill = "transparent", width = unit(8, "inches"), box.color = "transparent", 
    margin = margin(0, 0, 35, 0), hjust = 0, halign = 0
  ),
  plot.caption = element_markdown(
    size = rel(.5), color = grey_base, hjust = 0, margin = margin(t = 20, b = 0),
    family = 'sans'
  ),
  plot.title.position = "plot",
  plot.caption.position = "plot",
  plot.margin = margin(25, 25, 15, 25),
  plot.background = element_rect(fill = "white", color = "white"),
  legend.position = "none"
)

# annotations
title <- paste0(
"<b style='color:black;'>RGI*BWT:</b> Mapping reads to <b style='color:",
   pal_dark[1], ";'>CARD canonical</b> vs. <b style='color:", pal_dark[2], ";'>CARD variants</b>"
)
title <- paste0("")
caption <- paste0("")
callout <- paste0("")

# plot

n <- length(unique(df_matches$team)) - 1

p = ggplot(df_matches, aes(x = share, y = team)) +
    
    ## dumbbell segments
    stat_summary(
      geom = "linerange", fun.min = "min", fun.max = "max",
      linewidth = c(rep(.8, n), 0.8), color = c(rep(grey_base, n), grey_base)
    ) +
    
    ## dumbbell points
    ## white point to overplot line endings
    geom_point(
      aes(x = share), size = 6, shape = 21, stroke = 1, color = "white", fill = "white"
    ) +
    ## semi-transparent point fill
    geom_point(
      aes(x = share, fill = type), size = 6, shape = 21, stroke = 1, color = "white", alpha = .7
    ) +
    ## point outline
    geom_point(
      aes(x = share), size = 6, shape = 21, stroke = 1, color = "white", fill = NA
    ) +
    
    ## result labels
    geom_text(
      aes(label = percent(share, accuracy = 1, prefix = "    ", suffix = "%    "), 
          x = share -0.02, hjust = is_smaller-0.32, color = type),
      family = "sans", size = 4.2
    ) +
    
    ## legend labels
    annotate(
      geom = "text", x = c(.18, .60), y = n + 3.8, 
      label = c("CARD Cannonical", "CARD Variants"), family = "sans", 
      fontface = "bold", color = pal_base, size = 5, hjust = .5
    ) +
    
    ## call-out Eintracht
    geom_richtext(
      aes(x = .46, y = 3.3, label = callout), stat = "unique",
      family = "sans", size = 4, lineheight = 1.2,
      color = grey_base, hjust = 0, vjust = 1.03, fill = NA, label.color = NA
    ) +
    coord_cartesian(clip = "off") +
    scale_x_continuous(expand = expansion(add = c(.035, .05)), guide = "none") +
    scale_y_discrete(expand = expansion(add = c(.35, 1))) +
    scale_color_manual(values = pal_dark) +
    scale_fill_manual(values = pal_base) +
    labs(title = title, caption = caption) +
    theme(axis.text.y = element_text(face = c(rep("plain", n), "plain"), size=12))
    ggsave("web-dumbell-chart-clinical.png", width = 8.5, height = 9, dpi = 600)
