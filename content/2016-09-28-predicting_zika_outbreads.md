Title: Prediction of Zika Outbreaks
Date: 2016-09-28 20:14
Author: Michelle Gill
Slug: prediction_of_zika_outbreaks
Tags: machine learning, python, data science

I did it! My [final project](https://github.com/mlgill/wine-o.ai)[^tocome] for Metis's Data Science Bootcamp was presented just over a week ago. Before the dust completely settles on this wonderful experience, I'd like to share a few of my projects with you in the coming days.

The first of these projects involved predicting Zika outbreaks ([GitHub repo](https://github.com/mlgill/zika_prediction)). This project was for the supervised machine learning portion of the bootcamp. We also learned PostgreSQL and D3 for this project, which were used for data storage and visualization, respectively.

[^tocome]: Look for a blog post on this project next week!


## Data and Feature Engineering

Data was gathered from many sources, including GitHub repos and from web scraping, but the most critical was the CDC's [Zika outbreak repo](https://github.com/cdcepi/zika).[^1] Other data sources included historical weather, airport location, GDP, population density, and historical sightings of the mosquitoes *Aedes aegpti* and *Aedes albopictus*.[^2] Though not used as a feature, latitude and longitude were required for each location to enable feature engineering based on proximity. This proved rather challenging to acquire, given the limited number of APIs and sensitivity to variability in location spelling.

<img alt="Figure 1. The Aedes aegpti mosquito." src="https://mlgill.github.io/zika_prediction/figures/aedes-aegypti.jpg" width="600px">

[^1]: The recent trend of making data sets such as the Zika outbreak data readily available (and actively updated) on GitHub is incredibly exciting. The availability of this data enables anyone to make contributions to scientific problems. Working with relevant and current data also makes learning exercises such as this one much more fun!

[^2]: Other details about the data are available in the [README](https://github.com/mlgill/zika_prediction#data-sources) for the GitHub repo. 

To make this project approachable in a short time frame using basic machine learning methods, some compromises had to be made with regards to the data and modeling. First, most machine learning methods--including those taught by Metis--aren't able to correctly handle time series data, such as disease outbreaks. Second, the greater motivation to report and collect data from regions where outbreaks are likely or on-going resulted in a significant class imbalance in the Zika data. 

To address these issues, some simplifications were made in the treatment of the data. Specifically, locations were binned into two groups: (1) those which reported a disease occurrence at any point in time for which data were available, and (2) locations that did not have any occurrence of Zika. For locations with an occurrence of Zika, time dependent features--namely, weather--were used for the two weeks leading up to the outbreak.[^3] For other locations, the two weeks of historical weather were selected based on the date of first available data. 

As is discussed in the results, weather features ended up being critical to prediction. Undoubtedly, some of this correlation pertains to location--i.e. locations reporting Zika cases all have similar weather, while locations free of Zika are more remote. However, additional leverage was likely given to weather in some instances since the date could have been selected from a different season. 

[^3]: Two weeks of historical weather were used because the lifespan of a mosquito from egg to adult is about [8-10 days](http://www.cdc.gov/dengue/resources/factSheets/MosquitoLifecycleFINAL.pdf).

## Machine Learning

To predict Zika outbreaks, the following machine learning methods were tested: logistic regression, linear support vector machines, random forest, and AdaBoost. AdaBoost performed the best, with a precision of 0.90 and recall of 0.98 (*see figure below*).[^4] This result is expected given that the class imbalance issue has not been completely alleviated. 

To further address the problem of class imbalance, the minority class was over-sampled using ADASYN with [imbalanced-learn](http://contrib.scikit-learn.org/imbalanced-learn/). Over-sampling increases precision to 0.93 but decreases recall to 0.94.

[^4]: Note that, in the case of class imbalances such as this, the performance on the minority class is actually rather poor even though the metrics are excellent, as can be seen from the confusion matrix. In this case, however, the majority class just happens to be the one of greatest interest, so this isn't such a problem. 

<img alt="Figure 2. Confusion matrix from AdaBoost for normal and over-sampled data. Metrics are also shown for both models." src="https://mlgill.github.io/zika_prediction/figures/model_stats.png">

Comparing the normal and over-sampled models nicely illustrates the trade-off between precision and recall. In the case of disease prediction, recall is likely most important and the focus would probably be on the model that is not over-sampled. However, if false positives were problematic, say due to costs associated with unnecessary preparedness, then the focus could be shifted to the over-sampled model. Finally, ensembling these two models is another possibility that I didn't have time to test thoroughly.

Based on the various machine learning methods tested, weather features, including maximum and minimum temperature and precipitation, are the most important to the model. Population density and GDP also seem to play a role. As was mentioned above, it would be informative to explore the effects of class binning on the importance of these features. Given additional time, it would also be interesting to incorporate features pertaining to quality of health care system and education since Zika is also a sexually transmitted disease.

## Visualization of Outbreak Progress

Learning D3 was a fun and very challenging aspect of this project. I decided to create an animated map of the progression of Zika incidents. Each dated report is plotted according to date, latitude, and longitude on the map. The reports are color coded by actual and predicted outbreak status (red = disease, blue = no disease), with the fill of each incident corresponding to the actual status and the outline corresponding to predicted status. The diameter of the incident corresponds to the number of cases.

The visualization requires a web server, so a movie has been embedded below, however the files are in the [GitHub repo](https://github.com/mlgill/zika_prediction/tree/master/map). Unfortunately, I was unable to get the date correctly formatted on the slider,[^5] so you'll have to take my word for it that the dates about two-thirds of the way through the movie correspond to the outbreak this summer.

[^5]: If any of you are D3 wizards and know how to fix this, please feel free to point me to the solution or submit a pull request!

<script src="http://vjs.zencdn.net/4.0/video.js"></script>

<video id="visualizing-zika-outbreaks" class="video-js vjs-default-skin" controls
preload="none" width="870px" height="2000px" poster="https://mlgill.github.io/zika_prediction/figures/d3_visualization.png"
data-setup="{"playbackRates": [1, 1.5, 2]}">
<source src="https://mlgill.github.io/zika_prediction/figures/d3_visualization.mp4" type='video/mp4'>
</video>

## Conclusion

This project was a challenging and fun introduction to supervised machine learning, PostgreSQL, and D3. As always, there is more that can be done with data acquisition, feature engineering, and analysis. 

I think this project also highlights what I feel are two of the most important aspects of the design of Metis's bootcamp: (1) the use of self-designed projects, and (2) the use of real data, which is usually a requirement for self-designed projects. These two aspects of the bootcamp provide the opportunity to be creative and also to encounter (and overcome!) many of the pitfalls that arise in real world machine learning problems. 






