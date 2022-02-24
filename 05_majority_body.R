menu_majority <- tabItem(tabName = "majority",
                         fluidRow(
                           column(width = 12,
                                  tabBox(title ="majority工作台",width = 12,
                                         id='tabSet_majority',height = '300px',
                                         tabPanel('回料批次分析',tagList(
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
                                         tabPanel('回料还原入库(中台->ERP)',tagList(
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
                                         
                                         tabPanel('成本BOM',tagList(
                                           fluidRow(column(4,box(
                                             title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                             'sheet3'
                                           )),
                                           column(8, box(
                                             title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                             'rpt3'
                                           )
                                           ))
                                           
                                         )),
                                         tabPanel('成本结构分析',tagList(
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