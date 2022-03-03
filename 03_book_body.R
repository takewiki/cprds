menu_book <- tabItem(tabName = "book",
                     fluidRow(
                       column(width = 12,
                              tabBox(title ="book工作台",width = 12,
                                     id='tabSet_book',height = '300px',
                                     tabPanel('奖金提成规则',tagList(
                                       fluidRow(column(4,box(
                                         title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                       mdl_text('cp_pfm_rule_chooser',label = '请输入一个规则名称，不输入表示全部',value = ''),
                                       actionBttn(inputId = 'cp_pfm_rule_query',label = '查看明细'),br(),
                                       br(),
                                       hr(),
                                       mdl_text('cp_pfm_rule_new_FRuleName',label = '提成规则名称',value = ''),
                                       mdl_text('cp_pfm_rule_new_FParam_x',label = '提成系数x',value = ''),
                                       mdl_text('cp_pfm_rule_new_FParam_y',label = '止损系数y',value = ''),
                                       mdl_text('cp_pfm_rule_new_FParam_z',label = '类别系数z',value = ''),
                                       mdl_date('cp_pfm_rule_new_FStartDate',label = '生效日期',value =  as.Date('2021-04-01')),
                                       mdl_date('cp_pfm_rule_new_FEndDate',label = '失效日期',value =  as.Date('2100-12-31')),
                                       actionBttn(inputId = 'cp_pfm_rule_new',label = '新增明细'),br()
                                       
                                       
                                       )),
                                       column(8, box(
                                         title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         
                                         div(style = 'overflow-x: scroll', mdl_dataTable('cp_pfm_rule_dataView','预览管理成本'))
                                       )
                                       ))
                                       
                                     )),
                                     tabPanel('奖金提成测算',tagList(
                                       fluidRow(column(4,box(
                                         title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_ListChoose1(id = 'cp_pfm_rule_options',label = '请选择一个提成规则' ,choiceNames = cprdspkg::outstock_performance_rule_names(config_file = config_file),choiceValues = cprdspkg::outstock_performance_rule_names(config_file=config_file),selected =cprdspkg::outstock_performance_rule_names(config_file=config_file)[1] ),
                                         mdl_dateRange(id = 'cp_pfm_rule_dateRange',label = '请选择日期范围',
                                                       startDate = as.Date('2021-04-01'),
                                                       endDate = as.Date('2100-12-31')),
                                         actionBttn(inputId = 'cp_pfm_rule_calc',label = '计算提成')
                                       )),
                                       column(8, box(
                                         title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         div(style = 'overflow-x: scroll', mdl_dataTable('cp_pfm_calc_dataView','预览'))
                                       )
                                       ))
                                       
                                     )),
                                     tabPanel('奖金提成计提',tagList(
                                       fluidRow(column(4,box(
                                         title = "操作区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         mdl_ListChoose1(id = 'cp_pfm_res_options_query',label = '请选择一个提成规则' ,choiceNames = cprdspkg::outstock_performance_rule_names(config_file = config_file),choiceValues = cprdspkg::outstock_performance_rule_names(config_file=config_file),selected =cprdspkg::outstock_performance_rule_names(config_file=config_file)[1] ),
                                         mdl_dateRange(id = 'cp_pfm_res_dateRange_query',label = '请选择日期范围',
                                                       startDate = as.Date('2021-04-01'),
                                                       endDate = as.Date('2100-12-31')),
                                         actionBttn(inputId = 'cp_pfm_res_query',label = '查询提成'),
                                         mdl_download_button('cp_pfm_res_download',label = '下载提成')
                                       )),
                                       column(8, box(
                                         title = "报表区域", width = NULL, solidHeader = TRUE, status = "primary",
                                         div(style = 'overflow-x: scroll', mdl_dataTable('cp_pfm_res_dataView','预览'))
                                         
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