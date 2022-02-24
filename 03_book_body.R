menu_book <- tabItem(tabName = "book",
                     fluidRow(
                       column(width = 12,
                              tabBox(title ="book工作台",width = 12,
                                     id='tabSet_book',height = '300px',
                                     tabPanel('奖金提成规则',tagList(
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
                                     tabPanel('奖金提成测算',tagList(
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
                                     tabPanel('奖金提成计提',tagList(
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
                                     
                                     tabPanel('奖金提成发放',tagList(
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
                                     tabPanel('销售任务管理',tagList(
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
                                     tabPanel('销售数据报表',tagList(
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