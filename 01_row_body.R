menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(width = 12,
                             tabBox(title ="基础资料同步工作台",width = 12,
                                    id='tabSet_row',height = '300px',
                                    tabPanel('产品(ERP->CRM)',tagList(
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
                                    tabPanel('客户(CRM->ERP)',tagList(
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
                                    tabPanel('物料属性选项管理',tagList(
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
                                    
                                    tabPanel('物料属性类别管理',tagList(
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
                                    tabPanel('物料自动生成',tagList(
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
                                    tabPanel('物料按属性查询',tagList(
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
