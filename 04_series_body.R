menu_series<- tabItem(tabName = "series",
                      fluidRow(
                        column(width = 12,
                               tabBox(title ="series工作台",width = 12,
                                      id='tabSet_series',height = '300px',
                                      tabPanel('销售对账汇总表',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet1'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          
                                          'rpt1'
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('销售对账单',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet2'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'rpt2'
                                        )
                                        ))
                                        
                                      )),
                                      
                                      tabPanel('管理成本测算',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          tags$a(href='物料管理成本维护模板.xlsx','第一次使用,请下载物料管理成本维护模板'),
                                          mdl_file(id = 'cp_item_mngrCost_file',label = '请选择物料的管理成本文件'),
                                          actionBttn(inputId = 'cp_item_mngrcost_preview',label = '预览管理成本'),
                                          actionBttn(inputId = 'cp_item_mngrcost_update',label = '更新物料信息')
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          div(style = 'overflow-x: scroll', mdl_dataTable('cp_item_mngrcost_dataView','预览管理成本'))
                                          
                                        )
                                        ))
                                        
                                      )),
                                      tabPanel('销售价格测算',tagList(
                                        fluidRow(column(4,box(
                                          title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'sheet4'
                                        )),
                                        column(8, box(
                                          title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                          'rpt4'
                                        )
                                        ))
                                        
                                      ))
                                      
                                      
                                      
                               )
                        )
                      )
)