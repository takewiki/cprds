

#shinyserver start point----
 shinyServer(function(input, output,session) {
    #00-基础框设置-------------
    #读取用户列表
    user_base <- getUsers(conn_be,app_id)
    
    
    
    credentials <- callModule(shinyauthr::login, "login", 
                              data = user_base,
                              user_col = Fuser,
                              pwd_col = Fpassword,
                              hashed = TRUE,
                              algo = "md5",
                              log_out = reactive(logout_init()))
    
    
    
    logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
    
    observe({
       if(credentials()$user_auth) {
          shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
       } else {
          shinyjs::addClass(selector = "body", class = "sidebar-collapse")
       }
    })
    
    user_info <- reactive({credentials()$info})
    
    #显示用户信息
    output$show_user <- renderUI({
       req(credentials()$user_auth)
       
       dropdownButton(
          fluidRow(  box(
             title = NULL, status = "primary", width = 12,solidHeader = FALSE,
             collapsible = FALSE,collapsed = FALSE,background = 'black',
             #2.01.01工具栏选项--------
             
             
             actionLink('cu_updatePwd',label ='修改密码',icon = icon('gear') ),
             br(),
             br(),
             actionLink('cu_UserInfo',label = '用户信息',icon = icon('address-card')),
             br(),
             br(),
             actionLink(inputId = "closeCuMenu",
                        label = "关闭菜单",icon =icon('window-close' ))
             
             
          )) 
          ,
          circle = FALSE, status = "primary", icon = icon("user"), width = "100px",
          tooltip = FALSE,label = user_info()$Fuser,right = TRUE,inputId = 'UserDropDownMenu'
       )
       #
       
       
    })
    
    observeEvent(input$closeCuMenu,{
       toggleDropdownButton(inputId = "UserDropDownMenu")
    }
    )
    
    #修改密码
    observeEvent(input$cu_updatePwd,{
       req(credentials()$user_auth)
       
       showModal(modalDialog(title = paste0("修改",user_info()$Fuser,"登录密码"),
                             
                             mdl_password('cu_originalPwd',label = '输入原密码'),
                             mdl_password('cu_setNewPwd',label = '输入新密码'),
                             mdl_password('cu_RepNewPwd',label = '重复新密码'),
                             
                             footer = column(shiny::modalButton('取消'),
                                             shiny::actionButton('cu_savePassword', '保存'),
                                             width=12),
                             size = 'm'
       ))
    })
    
    #处理密码修改
    
    var_originalPwd <-var_password('cu_originalPwd')
    var_setNewPwd <- var_password('cu_setNewPwd')
    var_RepNewPwd <- var_password('cu_RepNewPwd')
    
    observeEvent(input$cu_savePassword,{
       req(credentials()$user_auth)
       #获取用户参数并进行加密处理
       var_originalPwd <- password_md5(var_originalPwd())
       var_setNewPwd <-password_md5(var_setNewPwd())
       var_RepNewPwd <- password_md5(var_RepNewPwd())
       check_originalPwd <- password_checkOriginal(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_originalPwd)
       check_newPwd <- password_equal(var_setNewPwd,var_RepNewPwd)
       if(check_originalPwd){
          #原始密码正确
          #进一步处理
          if(check_newPwd){
             password_setNew(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_setNewPwd)
             pop_notice('新密码设置成功:)') 
             shiny::removeModal()
             
          }else{
             pop_notice('两次输入的密码不一致，请重试:(') 
          }
          
          
       }else{
          pop_notice('原始密码不对，请重试:(')
       }
       
       
       
       
       
    }
    )
    
    
    
    #查看用户信息
    
    #修改密码
    observeEvent(input$cu_UserInfo,{
       req(credentials()$user_auth)
       
       user_detail <-function(fkey){
          res <-tsui::userQueryField(conn = conn_be,app_id = app_id,user =user_info()$Fuser,key = fkey)
          return(res)
       } 
       
       
       showModal(modalDialog(title = paste0("查看",user_info()$Fuser,"用户信息"),
                             
                             textInput('cu_info_name',label = '姓名:',value =user_info()$Fname ),
                             textInput('cu_info_role',label = '角色:',value =user_info()$Fpermissions ),
                             textInput('cu_info_email',label = '邮箱:',value =user_detail('Femail') ),
                             textInput('cu_info_phone',label = '手机:',value =user_detail('Fphone') ),
                             textInput('cu_info_rpa',label = 'RPA账号:',value =user_detail('Frpa') ),
                             textInput('cu_info_dept',label = '部门:',value =user_detail('Fdepartment') ),
                             textInput('cu_info_company',label = '公司:',value =user_detail('Fcompany') ),
                             
                             
                             footer = column(shiny::modalButton('确认(不保存修改)'),
                                             
                                             width=12),
                             size = 'm'
       ))
    })
    
    
    
    #针对用户信息进行处理
    
    sidebarMenu <- reactive({
       
       res <- setSideBarMenu(conn_rds('rdbe'),app_id,user_info()$Fpermissions)
       return(res)
    })
    
    
    #针对侧边栏进行控制
    output$show_sidebarMenu <- renderUI({
       if(credentials()$user_auth){
          return(sidebarMenu())
       } else{
          return(NULL) 
       }
       
       
    })
    
    #针对工作区进行控制
    output$show_workAreaSetting <- renderUI({
       if(credentials()$user_auth){
          return(workAreaSetting)
       } else{
          return(NULL) 
       }
       
       
    })
    var_cp_item_mngrCost_file <- var_file('cp_item_mngrCost_file')
    #物料管理成本预览--------
   observeEvent(input$cp_item_mngrcost_preview,{
     file_name = var_cp_item_mngrCost_file()
     if(is.null(file_name)){
       pop_notice('请选择一个文件')
     }else{
       data = cprdspkg::item_mngrCost_read(file_name = file_name)
       run_dataTable2('cp_item_mngrcost_dataView',data)
     }
     
     
   })
    #物料管理成本更新物料-------
    observeEvent(input$cp_item_mngrcost_update,{
      file_name = var_cp_item_mngrCost_file()
      if(is.null(file_name)){
        pop_notice('请选择一个文件')
      }else{
        cprdspkg::item_mngrCost_update(config_file = config_file ,file_name = file_name)
        pop_notice('更新成功！')
      }
      
      
    })
    #查看规则
    var_cp_pfm_rule_chooser <- var_text('cp_pfm_rule_chooser')
    observeEvent(input$cp_pfm_rule_query,{
      FRuleName = var_cp_pfm_rule_chooser()
      # print(FRuleName)
      data = cprdspkg::outstock_performance_rule_query(config_file = config_file,FName = FRuleName)
      run_dataTable2(id = 'cp_pfm_rule_dataView',data = data)
      
    })
    
    
    #新增提成规则
    var_cp_pfm_rule_new_FRuleName = var_text('cp_pfm_rule_new_FRuleName')
    var_cp_pfm_rule_new_FParam_x = var_text('cp_pfm_rule_new_FParam_x')
    var_cp_pfm_rule_new_FParam_y = var_text('cp_pfm_rule_new_FParam_y')
    var_cp_pfm_rule_new_FParam_z = var_text('cp_pfm_rule_new_FParam_z')
    var_cp_pfm_rule_new_FStartDate = var_date('cp_pfm_rule_new_FStartDate')
    var_cp_pfm_rule_new_FEndDate = var_date('cp_pfm_rule_new_FEndDate')
    observeEvent(input$cp_pfm_rule_new,{
      FName = var_cp_pfm_rule_new_FRuleName()
      FParam_x = var_cp_pfm_rule_new_FParam_x()
      FParam_y = var_cp_pfm_rule_new_FParam_y()
      FParam_z = var_cp_pfm_rule_new_FParam_z()
      FStartDate = var_cp_pfm_rule_new_FStartDate()
      FEndDate = var_cp_pfm_rule_new_FEndDate()
      flag = 1
      if (FName == ''){
        pop_notice('请输入规则名称')
        
        flag =0
      }
      if (FParam_x == ''){
        pop_notice('提成系数x')
        
        flag =0
      }
      if (FParam_y == ''){
        pop_notice('止损系数y')
        
        flag =0
      }
      if (FParam_z == ''){
        pop_notice('类别系数z')
        
        flag =0
      }
      
      if(flag == 1){
        cprdspkg::outstock_performance_rule_new(config_file = config_file,
                                                FName = FName,
                                                FParam_x = as.numeric(FParam_x),
                                                FParam_y = as.numeric(FParam_y),
                                                FParam_z = as.numeric(FParam_z) ,
                                                FStartDate = as.character(FStartDate) ,
                                                FEndDate = as.character(FEndDate))
        pop_notice('新增规则成功')
        
      }
      
      
      
    })
    #计算提成
    var_cp_pfm_rule_options = var_ListChoose1('cp_pfm_rule_options')
    var_cp_pfm_rule_dateRange =var_dateRange('cp_pfm_rule_dateRange')
    observeEvent(input$cp_pfm_rule_calc,{
      FRuleName = var_cp_pfm_rule_options()
      #print(FRuleName)
      dates = var_cp_pfm_rule_dateRange()
      #print(dates)
      FStartDate = as.character(dates[1])
      FEndDate = as.character(dates[2])
      try({
        cprdspkg::outstock_performance_calc(config_file = config_file,FRuleName =FRuleName ,FStartDate = FStartDate,FEndDate = FEndDate)
      })
      
      pop_notice('提成计算成功')
      
 
      
    })
    #提成查询及下载-----
    var_cp_pfm_res_options_query = var_ListChoose1('cp_pfm_res_options_query')
    var_cp_pfm_res_dateRange_query =var_dateRange('cp_pfm_res_dateRange_query')
    observeEvent(input$cp_pfm_res_query,{
      
      FRuleName = var_cp_pfm_res_options_query()
      dates = var_cp_pfm_res_dateRange_query()
      FStartDate = as.character(dates[1])
      FEndDate = as.character(dates[2])
      file_name = paste0("提成明细下载_",FRuleName,"_",FStartDate,"_",FEndDate,".xlsx")
      data = cprdspkg::outstock_performance_query(config_file = config_file,FRuleName =FRuleName ,FStartDate = FStartDate,FEndDate = FEndDate)
      run_dataTable2('cp_pfm_res_dataView',data = data)
      run_download_xlsx(id = 'cp_pfm_res_download',data = data,filename = file_name)
      
      
      
      
    })
    #对账单预览----
    var_cp_dzd_initData_file <- var_file('cp_dzd_initData_file')
    observeEvent(input$dzd_initData_query,{
      file_name = var_cp_dzd_initData_file()
      if(is.null(file_name)){
        pop_notice('请选择一个文件')
      }else{
        data = cprdspkg::dzd_initData_read(file_name = file_name,lang = 'cn')
        run_dataTable2(id = 'dzd_initData_dataView',data = data)
      }
     
    })
    observeEvent(input$dzd_initData_update,{
      file_name = var_cp_dzd_initData_file()
      if(is.null(file_name)){
        pop_notice('请选择一个文件')
      }else{
        data = cprdspkg::dzd_initData_read(file_name = file_name,lang = 'en')
        ncount = nrow(data)
        if(ncount >0){
          try({
            cprdspkg::dzd_initData_updateAll(config_file = config_file,data = data)
            pop_notice('更新成功')
          })
        }else{
          pop_notice('更新失败')
          
        }
        
      }
      
      
    })
    
    #BOM管理------
    #处理BOM管理----
    
    
    #预览页签
    observeEvent(input$bq_sheet_preview,{
      
      file <- file_bom()
      data <- lcrdspkg::lc_bom_sheetName(file)
      data2 <- data.frame(`页签名称` = data,stringsAsFactors = F)
      run_dataTable2('bq_sheet_dataPreview',data2)
      
      
    })
    
    #跳转到G翻转表
    observeEvent(input$bq_toGtab,{
      updateTabsetPanel(session, "tabset_bomQuery",
                        selected = "G番表")
    })
    
    #格式化G翻转表
    file_bom <- var_file('bq_file')
    #选定的页答
    var_include_sheet <- var_text('bq_sheet_select')
    
    observeEvent(input$bq_formatG,{
      file <- file_bom()
      
      include_sheetNames <- var_include_sheet()
      print(include_sheetNames)
      if(is.null(include_sheetNames)){
        include_sheetNames <-NA
      }
      print(include_sheetNames)
      if(tsdo::len(include_sheetNames) == 0){
        include_sheetNames <-NA
      }
      
      print(include_sheetNames)
      lcrdspkg::Gtab_batchWrite_db(conn=conn_bom,file = file,include_sheetNames = include_sheetNames,show_progress = TRUE)
      
      pop_notice('G番表完成处理')
    })
    
    
    #处理下载数据--
    var_gtab_chartNo <- var_text('bq_Gtab_chartNo_input')
    
    data_gtab_dl <- eventReactive(input$bq_Gtab_chartNo_preview,{
      
      FchartNo <-var_gtab_chartNo()
      res <-lcrdspkg::Gtab_selectDB_byChartNo2(conn = conn_bom,FchartNo =FchartNo )
      return(res)
    })
    
    observeEvent(input$bq_Gtab_chartNo_preview,{
      
      data <- data_gtab_dl()
      FchartNo <-var_gtab_chartNo()
      filename <- paste0(FchartNo,"_G番表.xlsx")
      run_dataTable2('bq_Gtab_chartNo_dataShow',data = data)
      run_download_xlsx('bq_Gtab_chartNo_dl',data = data,filename = filename)
      
    })
    
    
    
    
    
    #跳转到L番表
    observeEvent(input$bq_goLtab,{
      updateTabsetPanel(session, "tabset_bomQuery",
                        selected = "L番表")
      
    })
    
    observeEvent(input$bq_formatL,{
      file <- file_bom()
      
      include_sheetNames <- var_include_sheet()
      print(include_sheetNames)
      if(is.null(include_sheetNames)){
        include_sheetNames <-NA
      }
      if(tsdo::len(include_sheetNames) == 0){
        include_sheetNames <-NA
      }
      print(include_sheetNames)
      lcrdspkg::Ltab_batchWrite_db(conn = conn_bom,file = file,include_sheetNames = include_sheetNames,show_progress = TRUE)
      pop_notice('L番表完成处理')
      
    })
    
    #处理L翻转表数据
    var_ltab_chartNo <- var_text('bq_Ltab_chartNo_input')
    
    data_ltab_dl <- eventReactive(input$bq_Ltab_chartNo_preview,{
      
      FchartNo <-var_ltab_chartNo()
      res <-lcrdspkg::Ltab_select_db2(conn=conn_bom,FchartNo = FchartNo)
      return(res)
    })
    
    observeEvent(input$bq_Ltab_chartNo_preview,{
      
      data <- data_ltab_dl()
      FchartNo <-var_ltab_chartNo()
      filename <- paste0(FchartNo,"_L番表.xlsx")
      run_dataTable2('bq_Ltab_chartNo_dataShow',data = data)
      run_download_xlsx('bq_Ltab_chartNo_dl',data = data,filename = filename)
      
    })
    
    
    #跳转到BOM运算
    
    observeEvent(input$bq_goCalcBom,{
      updateTabsetPanel(session, "tabset_bomQuery",
                        selected = "BOM运算")
      
      
      
    })
    #实现BOM运算逻辑
    observeEvent(input$bq_calcBom,{
      
      lcrdspkg::dm_dealAll2(conn=conn_bom,show_process = TRUE)
      pop_notice('BOM运算已完成')
      
      
      
    })
    
    #配置BOM速查---
    
    var_FchartNo <- var_text('bq_spare_partNo')
    var_FGtab <- var_text('bq_spare_GNo')
    var_FLtab <- var_text('bq_spare_LNo')
    db_bom_spare <- eventReactive(input$bq_spare_preview,{
      FchartNo <- var_FchartNo()
      FGtab <- var_FGtab()
      FLtab <- var_FLtab()
      
      res<- lcrdspkg::dm_selectDB_detail2(conn=conn_bom,FchartNo = FchartNo,FParamG = FGtab,FParamL = FLtab)
      return(res)
      
    })
    
    observeEvent(input$bq_spare_preview,{
      data <- db_bom_spare()
      
      run_dataTable2('bq_spare_dataShow',data = data)
      pop_notice('配件查询已完成')
      run_download_xlsx('bq_spare_download',data = data,filename = '配件BOM查询下载.xlsx')
    })
    
    #处理DM数据--
    var_file_dm <- var_file('bq_dm_file')
    #处理相关数据
    
    data_dm_detail <- eventReactive(input$bq_DM_preview,{
      file <- var_file_dm()
      print(file)
      sheetName <- input$bq_dm_sheetName
      print(sheetName)
      #res <- lcrdspkg::dm_queryAll(file = file,sheet = sheetName,conn = conn_bom)
      res <- lcrdspkg::dmList_Expand_Multi(file=file,sheet = sheetName,conn=conn_bom)
      #print(res)
      return(res)
    })
    
    observeEvent(input$bq_DM_preview,{
      print('A')
      data <- data_dm_detail()
      print(data)
      run_dataTable2('bq_DM_dataShow',data = data)
      run_download_xlsx('bq_DM_download',data = data,filename = 'DM清单明细.xlsx')
      
      
    })
    
    
    #DM单单个查询-------
    #var_dm1_dmno <- var_text('dm1_dmno')
    observeEvent(input$dm1_preview,{
      FDmNo = input$dm1_dmno
      print(FDmNo)
      data <-try(lcrdspkg::dmQuery1_readDB_cn(conn=conn_bom,FDmNo = FDmNo))
      run_dataTable2('dm1_dataShow',data = data)
      file_name <- paste0(FDmNo,"_DM清单明细查询.xlsx")
      run_download_xlsx(id = 'dm1_dl',data = data,filename = file_name)
    })
    
    
    
    
    
    #针对物料匹配表进行处理---
    
    run_download_xlsx(id = 'map_tpl_dl',data = get_chartMtrlMap_tpl(),filename = '图号物料匹配表模板.xlsx')
    
    
    
    
    #下载模板
    run_download_xlsx('bom_split_tml_dl',data=get_bom_split_tpl(),filename = 'BOM拆分模板.xlsx')
    
    #上传服务器
    var_bom_split_file <- var_file('bom_split_file')
    observeEvent(input$bom_split_upload,{
      file <- var_bom_split_file()
      data <- readxl::read_excel(path = file,sheet = 'BOM拆分')
      FChartNo <- data$`图号`  
      res <- try(lcrdspkg::bom_split(mtrl_multiple_G = FChartNo))
      ncount <- nrow(res)
      if(ncount >0){
        info <- res
        #上传数据
        lcrdspkg::bom_split_upload(conn = conn_bom,data = info)
        names(info) <-c('序号','主图号','分录号','子图号')
        #上传数据
        rownames(info) <- NULL
      }else{
        info <- data.frame(`反馈结果`='没有查到任何数据',stringsAsFactors = F)
      }
      run_dataTable2('bom_split_dataShow',data = info)
      #提示信息
      pop_notice('数据已上传服务器!')
      file_res_name <- paste0("BOM拆分结果_",as.character(Sys.Date()),".xlsx")
      run_download_xlsx(id = 'bom_split_res_dl',data = info,filename = file_res_name)
      
      
      
    })
    
    #查询数据
    observeEvent(input$bom_split_query_btn,{
      
      data <- lcrdspkg::bom_split_query(conn=conn_bom,FBillNo = input$bom_split_query_txt)
      
      run_dataTable2('bom_split_query_dataShow',data = data)
      #下载
      file_res_name <- paste0("BOM拆分查询结果_",as.character(Sys.Date()),".xlsx")
      run_download_xlsx(id = 'bom_split_query_dl',data = data,filename = file_res_name)
    })
    
    #添加条码功能模板
    run_download_xlsx(id = 'ext_barCode_tpl_dl',data = get_extBarCode_tpl(),filename = '外部订单模板.xlsx')
    #订单备注信息处理
    run_download_xlsx(id = 'ext_soNote_tpl_dl',data = lcrdspkg::soNote_data_tpl(),filename = '技术订单备注上传模板.xlsx')
    run_download_xlsx(id = 'ext_soNote_tpl_dl2',data = lcrdspkg::soNote_data_tpl(),filename = '生产订单备注上传模板.xlsx')
    var_file_so_note <- var_file('file_so_note')
    var_file_so_note2 <- var_file('file_so_note2')
    
    
    
    
    
   
  
})
