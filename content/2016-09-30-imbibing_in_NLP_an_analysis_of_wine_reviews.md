Title: Imbibing in NLP: an Analysis of Wine Reviews
Date: 2016-09-30 20:14
Author: Michelle Gill
Slug: imbibing_in_NLP_an_analysis_of_wine_reviews
Tags: machine learning, natural language processing, python, data science
Status: Draft

## Analysis and Results

I scraped 190,000 expert wine reviews from [Wine Enthusiast](http://wineenthusiast.com). Reviews from additional websites were also scraped. However, professional reviews seemed to cluster the best during analysis. 

Four clusters were identified during the analysis. Based on wordclouds (below), these clusters were named as follows:

1. Spicy Reds
2. White Wines
3. Sweet Reds
4. Portugese Reds

<!-- ![](./figures/10_wine_enthusiast_wordcloud.png) -->

These clusters persisted in the LDA model as well.

<!-- ![](./figures/10_gensim_analysis_lda_vis_4.png) -->

There also appears to be some correlation between vintage years and review sentiment.

<!-- ![](./figures/11_wine_enthusiast_sentiment.png) -->