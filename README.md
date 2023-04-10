## Analysis of Bank Customers Using SQL

Creation of a denormalized table that contains behavioral indicators on the customers, calculated on the basis of transactions and products ownership. The aim is to create the features for a possible supervised machine learning model.

In particular the features to create, for each client_id, are the following:
* _Age;_
* _Number of outgoing transactions on all accounts;_
* _Number of incoming transactions on all accounts;_
* _Outgoing amount transacted on all accounts;_
* _Amount transacted on all accounts;_
* _Total number of accounts held;_
* _Number of accounts held by type (one indicator per type);_
* _Number of outgoing transactions by type (one indicator per type);_
* _Number of incoming transactions by type (one indicator per type);_
* _Outgoing amount transacted by account type (one indicator per type);_
* _Incoming amount transacted by account type (one indicator per type)._
