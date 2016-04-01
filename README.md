# Indoor-Localization-System
Sensor nodes need to communicate with each other within a Wireless Sensor Network. When one of the nodes (target node) moves around the whole area while others (anchor nodes) are fixed, its received signal strength from other nodes would change since signal strength would change by the distance. That is to say, target node in every different location within the area would have different signal strength value from other anchor nodes. Thus, based on this variance, we are able to build a model to predict the location.

Here I use the Naïve Bayes classification method. After pre-processing the data, I train a classifier with it in R. Then use it to predict the location of target node based on new upcoming signal strength data and show the result in a Java GUI.
