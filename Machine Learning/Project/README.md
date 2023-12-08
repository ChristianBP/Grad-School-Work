## Machine Learning Final Project
#### Christian Parker
# Wine Variety Prediction
> This project requires that these packages be installed.

> `pip install pandas scikit-learn keras simpletransformers`

This project is broken up into three sub-sections: Point Predictions, Sequence Predictions, and Word Count Predictions.
To run each of these you will have to first open their notebook in a Jupyter environment.

### Point Predictions
For point predictions, you must execute the first two cells to filter and then modify the data. At this point you can execute the algorithms in any order and any number of times as well as change their hyperparameters as you see fit. Here's a list of the algorithms and their hyperparameters:
- SVM
    - Max iterations
    - C (regularization parameter)
- K Neighbors
    - Number of neighbors
- Decision Tree Classifier
    - Max depth
- Random Forest
    - Max depth
    - Number of estimators
- Hist Gradient Boosting
    - Max depth
    - Max iterations
- Gradient Boosting
    - Max depth
    - Number of estimators

### Sequence Predictions
For sequence predictions, you must execute the first cell to filter the data before running the transformer. The first two cells must be run before running the recurrent neural network so that the features can be tokenized.

### Word Count Predictions
For word count predictions, you must execute the first two cells to filter and then tokenize the data. After this you can run Naive Bayes and the Feed Forward Neural Network in any order and any number of times.