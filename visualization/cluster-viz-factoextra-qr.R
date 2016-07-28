# Principal component analysis
# ++++++++++++++++++++++++++++++
data(iris)
res.pca <- prcomp(iris[, -5],  scale = TRUE)

# Graph of individuals
# +++++++++++++++++++++

# Default plot
fviz_pca_ind(res.pca, col.ind = "#00AFBB")

# 1. Control automatically the color of individuals 
# using the "cos2" or the contributions "contrib"
# cos2 = the quality of the individuals on the factor map
# 2. To keep only point or text use geom = "point" or geom = "text".
# 3. Change themes: http://www.sthda.com/english/wiki/ggplot2-themes

fviz_pca_ind(res.pca, col.ind="cos2", geom = "point")+
  theme_minimal() 

# Change gradient color
# Use repel = TRUE to avoid overplotting (slow if many points)
fviz_pca_ind(res.pca, col.ind="cos2", repel = TRUE) + 
  scale_color_gradient2(low = "white", mid = "#2E9FDF", 
                        high= "#FC4E07", midpoint=0.6, space = "Lab")+
  theme_minimal()

# Color individuals by groups, add concentration ellipses
# Remove labels: label = "none".
p <- fviz_pca_ind(res.pca, label="none", habillage=iris$Species,
                  addEllipses=TRUE, ellipse.level=.95)
print(p)

# Change group colors using RColorBrewer color palettes
# Read more: http://www.sthda.com/english/wiki/ggplot2-colors
p + scale_color_brewer(palette="Dark2") +
  scale_fill_brewer(palette="Dark2") +
  theme_minimal()

# Change group colors manually
# Read more: http://www.sthda.com/english/wiki/ggplot2-colors
p + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9"))+
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"))+
  theme_minimal()  

# Select and visualize some individuals (ind) with select.ind argument.
# - ind with cos2 >= 0.96: select.ind = list(cos2 = 0.96)
# - Top 20 ind according to the cos2: select.ind = list(cos2 = 20)
# - Top 20 contributing individuals: select.ind = list(contrib = 20)
# - Select ind by names: select.ind = list(name = c("23", "42", "119") )

# Example: Select the top 40 according to the cos2
fviz_pca_ind(res.pca, select.ind = list(cos2 = 40))


# Graph of variables
# ++++++++++++++++++++++++++++

# Default plot
fviz_pca_var(res.pca, col.var = "steelblue")+
  theme_minimal()


# Control variable colors using their contributions
fviz_pca_var(res.pca, col.var = "contrib")+
  scale_color_gradient2(low="white", mid="blue", 
                        high="red", midpoint=96, space = "Lab") +
  theme_minimal()  

# Select variables with select.var argument
# You can select by contrib, cos2 and name 
# as previously described for ind
# Select the top 3 contributing variables
fviz_pca_var(res.pca, select.var = list(contrib = 3))

# Biplot of individuals and variables
# ++++++++++++++++++++++++++
fviz_pca_biplot(res.pca)


# Keep only the labels for variables
# Change the color by groups, add ellipses
fviz_pca_biplot(res.pca, label = "var", habillage=iris$Species,
                addEllipses=TRUE, ellipse.level=0.95)+
  theme_minimal()

set.seed(123)

# Data preparation
# +++++++++++++++
data("iris")
head(iris)
# Remove species column (5) and scale the data
iris.scaled <- scale(iris[, -5])

# K-means clustering
# +++++++++++++++++++++
km.res <- kmeans(iris.scaled, 3, nstart = 25)

# Visualize kmeans clustering
# use repel = TRUE to avoid overplotting
fviz_cluster(km.res, iris[, -5], frame.type = "convex")

# Change the color and theme
fviz_cluster(km.res, iris[, -5]) + 
  scale_color_brewer(palette = "Set2")+
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()

fviz_pca_ind(res.pca, col.ind="cos2", repel = TRUE) + 
  scale_color_gradient2(low = "white", mid = "#2E9FDF", 
                        high= "#FC4E07", midpoint=0.6, space = "Lab")+
  theme_minimal()

