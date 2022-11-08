## SQL_for_Data_Science

Creation of a denormalized table that contains behavioral indicators on the customers, calculated on the basis of transactions and products ownership. The aim is to create the features for a possible supervised machine learning model.

In particular the features to create, for each client_id, are the following:
* _Age_
* _Number of outgoing transactions on all accounts_
* _Number of incoming transactions on all accounts_
* _Outgoing amount transacted on all accounts_
* _Amount transacted on all accounts_
* _Total number of accounts held_
* _Number of accounts held by type (one indicator per type)_
* _Number of outgoing transactions by type (one indicator per type)_
* _Number of incoming transactions by type (one indicator per type)_
* _Outgoing amount transacted by account type (one indicator per type)_
* _Incoming amount transacted by account type (one indicator per type)_
