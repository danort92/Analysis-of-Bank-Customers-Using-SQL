select 
cliente.*,

-- creation of "age" column 
case 
	when month(cliente.data_nascita)<month(current_date()) then year(current_date)-year(cliente.data_nascita)
	when month(cliente.data_nascita)>month(current_date()) then year(current_date)-year(cliente.data_nascita)-1
	when month(cliente.data_nascita)=month(current_date()) and day(cliente.data_nascita)<day(current_date()) then year(current_date)-year(cliente.data_nascita)
    when month(cliente.data_nascita)=month(current_date()) and day(cliente.data_nascita)>=day(current_date()) then year(current_date)-year(cliente.data_nascita)-1
    end as age,
 
 -- creation of two "number of transactions" columns, referred to income and to expenses respectively, calculated on all the accounts
count(case when conto_trans.segno="+" then "True" end) income_n°_transactions,
count(case when conto_trans.segno="-" then "True" end) expenses_n°_transactions,

-- creation of two "transactions amount" columns, referred to income and to expenses respectively, calculated on all the accounts
sum(case when conto_trans.segno="+" then conto_trans.importo else null end) income,
sum(case when conto_trans.segno="-" then conto_trans.importo else null end) expenses,

-- creation of "number of accounts" column
count(distinct conto_trans.id_conto) as n°_account,

-- creation of 4 "number of accounts" columns, one for each type of account
case when conto_base.cnt is null then 0 else conto_base.cnt end as account_basic,
case when conto_business.cnt is null then 0 else conto_business.cnt end as account_business,
case when conto_privati.cnt is null then 0 else conto_privati.cnt end as account_private,
case when conto_famiglie.cnt is null then 0 else conto_famiglie.cnt end as account_family,

-- creation of 7 "transactions amount" columns, one for each type of transaction
case when stipendio.cnt is null then 0 else stipendio.cnt end as salary,
case when pensione.cnt is null then 0 else pensione.cnt end as pension,
case when dividendi.cnt is null then 0 else dividendi.cnt end as dividends,
case when amazon.cnt is null then 0 else amazon.cnt end as amazon,
case when mutuo.cnt is null then 0 else mutuo.cnt end mortgage,
case when hotel.cnt is null then 0 else hotel.cnt end as hotel,
case when aereo.cnt is null then 0 else aereo.cnt end as airplane,
case when spesa.cnt is null then 0 else spesa.cnt end as shopping,

-- creation of 4 "transactions amount" columns, one for each type of account
case when entrate_conto_base.cnt is null then 0 else entrate_conto_base.cnt end as income_account__basic,
case when uscite_conto_base.cnt is null then 0 else uscite_conto_base.cnt end as expenses_account__basic,
case when entrate_conto_business.cnt is null then 0 else entrate_conto_business.cnt end as income_account_business,
case when uscite_conto_business.cnt is null then 0 else uscite_conto_business.cnt end as expenses_account_business,
case when entrate_conto_privati.cnt is null then 0 else entrate_conto_privati.cnt end as income_account_private,
case when uscite_conto_privati.cnt is null then 0 else uscite_conto_privati.cnt end as expenses_account_private,
case when entrate_conto_famiglie.cnt is null then 0 else entrate_conto_famiglie.cnt end as income_account_family,
case when uscite_conto_famiglie.cnt is null then 0 else uscite_conto_famiglie.cnt end as expenses_account_family

from banca.cliente cliente 
left join (select 
			conto.*, 
            trans_t_trans.data,trans_t_trans.id_tipo_trans,trans_t_trans.importo,trans_t_trans.segno
            from banca.conto conto 
            left join (select
						trans.*,
						t_trans.segno
						from banca.transazioni trans
						left join banca.tipo_transazione t_trans
						on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans 
            on conto.id_conto=trans_t_trans.id_conto) as conto_trans
on cliente.id_cliente=conto_trans.id_cliente

left join(select 
conto.*,
count(conto.id_tipo_conto) cnt
from banca.conto conto
where conto.id_tipo_conto=0
group by 2) conto_base
on cliente.id_cliente=conto_base.id_cliente
left join(select 
conto.*,
count(conto.id_tipo_conto) cnt
from banca.conto conto
where conto.id_tipo_conto=1
group by 2) conto_business
on cliente.id_cliente=conto_business.id_cliente
left join(select 
conto.*,
count(conto.id_tipo_conto) cnt
from banca.conto conto
where conto.id_tipo_conto=2
group by 2) conto_privati
on cliente.id_cliente=conto_privati.id_cliente
left join(select 
conto.*,
count(conto.id_tipo_conto) cnt
from banca.conto conto
where conto.id_tipo_conto=3
group by 2) conto_famiglie
on cliente.id_cliente=conto_famiglie.id_cliente

left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=0
group by 5) stipendio
on conto_trans.id_cliente=stipendio.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=1
group by 5) pensione
on conto_trans.id_cliente=pensione.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=2
group by 5) dividendi
on conto_trans.id_cliente=dividendi.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=3
group by 5) amazon
on conto_trans.id_cliente=amazon.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=4
group by 5) mutuo
on conto_trans.id_cliente=mutuo.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=5
group by 5) hotel
on conto_trans.id_cliente=hotel.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=6
group by 5) aereo
on conto_trans.id_cliente=aereo.id_cliente
left join(select
trans.*,conto.id_cliente,count(trans.id_tipo_trans) cnt
from banca.transazioni trans
left join banca.conto conto
on conto.id_conto=trans.id_conto
where trans.id_tipo_trans=7
group by 5) spesa
on conto_trans.id_cliente=spesa.id_cliente

left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=0
group by 7,8 having trans_t_trans.segno="+") entrate_conto_base
on conto_trans.id_cliente=entrate_conto_base.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=0
group by 7,8 having trans_t_trans.segno="-") uscite_conto_base
on conto_trans.id_cliente=uscite_conto_base.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=1
group by 7,8 having trans_t_trans.segno="+") entrate_conto_business
on conto_trans.id_cliente=entrate_conto_business.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=1
group by 7,8 having trans_t_trans.segno="-") uscite_conto_business
on conto_trans.id_cliente=uscite_conto_business.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=2
group by 7,8 having trans_t_trans.segno="+") entrate_conto_privati
on conto_trans.id_cliente=entrate_conto_privati.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=2
group by 7,8 having trans_t_trans.segno="-") uscite_conto_privati
on conto_trans.id_cliente=uscite_conto_privati.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=3
group by 7,8 having trans_t_trans.segno="+") entrate_conto_famiglie
on conto_trans.id_cliente=entrate_conto_famiglie.id_cliente
left join(select
trans_t_trans.*,conto.id_cliente,conto.id_tipo_conto,sum(trans_t_trans.importo) cnt
from banca.conto conto
left join(select *
from banca.transazioni trans
left join banca.tipo_transazione t_trans
on trans.id_tipo_trans=t_trans.id_tipo_transazione) as trans_t_trans
on conto.id_conto=trans_t_trans.id_conto
where conto.id_tipo_conto=3
group by 7,8 having trans_t_trans.segno="-") uscite_conto_famiglie
on conto_trans.id_cliente=uscite_conto_famiglie.id_cliente

-- each feature is specific client-specific
group by 1
