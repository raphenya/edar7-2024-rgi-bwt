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
    team = c(
        "W1S_AC1",
        "W1S_AC2",
        "W1S_AO1",
        "W1S_AO2",
        "W1S_CC1",
        "W1S_CC2",
        "W1S_HO1",
        "W1S_HO2",
        "W1S_SG1",
        "W1S_SG2",
        "W2S_AC1",
        "W2S_AC2",
        "W2S_AO1",
        "W2S_AO2",
        "W2S_CC1",
        "W2S_CC2",
        "W2S_HO1",
        "W2S_HO2",
        "W2S_SG1",
        "W2S_SG2"),
     matches = c(rep(100,20)), # total reads per sample
     won =     c(
                53,
                51,
                51,
                51,
                51,
                51,
                52,
                51,
                83,
                82,
                51,
                53,
                51,
                51,
                51,
                51,
                53,
                53,
                78,
                77), # mapped reads per sample (wild)
    lost =    c(
                47,
                49,
                49,
                49,
                49,
                49,
                48,
                49,
                17,
                18,
                49,
                47,
                49,
                49,
                49,
                49,
                47,
                47,
                22,
                23) # mapped reads per sample (cannonical)
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
      fontface = c(rep("plain", n*2), rep("plain", 2)),
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

    ggsave("web-dumbell-chart-wastewater.png", width = 8.5, height = 9, dpi = 600)
