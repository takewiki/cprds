

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
    
    
   
  
})
