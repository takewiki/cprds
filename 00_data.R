# 设置app标题-----
# 1.3

app_title <-'赛普生物数据中台V2.2';

# store data into rdbe in the rds database
app_id <- 'cprds'

#设置数据库链接---

conn_be <- conn_rds('rdbe')



#设置链接---
conn <- conn_rds('nsic')

conn_bom <- conn_rds('cpbom')




config_file = 'config/conn_erp.R'
