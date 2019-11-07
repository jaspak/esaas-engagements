class MyprojectsController < ApplicationController
    
    def index
        user = current_user
        orgs = Org.for_user(user.id)
        deploy_vet_map(orgs)
        total_app = @total_deploy + @total_vet
        page_default_and_update("myprojects", total_app)
        change_page_num("myprojects", total_app)

        @apps = App.for_orgs(orgs, limit=@each_page, offset=@each_page*(@page_num-1)).sort_by_status
        respond_to do |format|
            format.json { render :json => @apps.featured }
            format.html
        end
    end

    # GET /myprojects/1
    def show
        @current_user = User.find_by_id(session[:user_id])
        @current_user_orgs = Org.for_user(@current_user.id)
        @current_user_apps = App.for_orgs(@current_user_orgs)

        # Check if the specified app exists, and if it does, set it to @app
        if App.exists?(params[:id])
            @app = App.find(params[:id])
            @comments = @app.comments
        else
            flash.alert = "You do not have any projects with ID :#{params[:id]}."
            redirect_to myprojects_path and return
        end

        # Check if @app belongs to @current_user
        unless @current_user_apps.exists?(@app.id)
            flash.alert = "You do not have any projects with ID :#{params[:id]}."
            redirect_to myprojects_path
        end
    end


    def deploy_vet_map(orgs=nil)
        status_map = App.status_count_for_orgs(orgs)
        @deployment_map = {}
        @vetting_map = {}
        @total_deploy = 0
        @total_vet = 0
        status_map.each do |status, count|
            status_str = App.statuses.keys[status]
            if App.getAllVettingStatuses.include? status_str.to_sym
                @vetting_map[status_str] = count
                @total_vet += count
            else
                @deployment_map[status_str] = count
                @total_deploy += count
            end
        end
    end
end