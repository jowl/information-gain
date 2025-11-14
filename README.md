# Information gain

This is a utility script to calculate information gain and related information entropy measures based on a JSON input.

Provided a measure and a label (the JSON key which represents the random variable you wish to classify), the script calculates the selected measure for all features (other keys present in the JSON input).

## Measures

It supports three measures; information gain, intrinsic value, and information gain ratio. Below are overly simplified descriptions of these.

### Information gain

Information gain can be thought to represent the amount of information about `label` you get from the analysed feature. A higher information gain, means that you have a higher probability of predicting the value of `label` if you know the value of the feature.

### Intrinsic value

The intrinsic value of a feature does not relate to it's correlation to `label`, but rather is a measure of its cardinality and thus the potential information it might hold.

### Information gain ratio

The information gain ratio is the ratio between information gain and intrinsic value, and is thus a way of normalising the features based on their cardinality. E.g. if each entry in the JSON input contains a unique timestamp, the information gain from this feature would be high as it could be used to accurately predict the value of `label`, but since the intrinsic value would also be high, the ratio would be lower and thus indicate that it might not be a reliable classifier.

## Running

The repository contains a small dataset to understand the tool:

```
$ bin/information-gain --label "Play Tennis" --measure gain --format json < example-data/tennis.json
gain	feature	entropy
0.940	Day	0.940
0.247	Outlook	0.940
0.152	Humidity	0.940
0.048	Windy	0.940
0.029	Temp	0.940
```

The output tells you that the total entropy for the `Play Tennis` label is 0.940, and then lists the information gain for each feature. Based on the output, `Day` is the most likely to predict `Play Tennis`, followed by `Outlook`.

If we swap `gain` for `ratio`, we get the following:

```
$ bin/information-gain --label "Play Tennis" --measure ratio --format json < example-data/tennis.json
ratio	feature	entropy
0.247	Day	0.940
0.156	Outlook	0.940
0.152	Humidity	0.940
0.049	Windy	0.940
0.019	Temp	0.940
```

Where we see that the relative information between `Day` and `Outlook` is much lower, due to the high cardinality of `Day`. This indicates that the correlation between `Day` and `Play Tennis` is not as strong as the information gain indicated.


## References

https://en.wikipedia.org/wiki/Information_gain_ratio
