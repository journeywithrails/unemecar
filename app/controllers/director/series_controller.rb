class Director::SeriesController < ApplicationController
  before_filter :login_required, :set_director_event
  
  def index
    begin
      @series_list = Series.find(:all)
    rescue
    end
  end
  
  def new
    @series = Series.new
  end
  
  def create
     #~ begin
     #~ render :text => "problem" and return
    @series = Series.new(params[:series])
    if @series.save!
      flash[:notice] = "Series has created successfully"
      redirect_to :action => :index
    else
      render :text => "problem" and return
      #~ render :action => :new,:evid => params[:evid]
    end
    #~ rescue     
     #~ render :text => "probledsfsdf" and return
    #~ end
  end
  
  def edit
    begin
      @series = Series.find(params[:id])     
    rescue
    end
  end
  
  def update    
    begin
      @series = Series.find(params[:id])
      @series.update_attributes(params[:series])
      flash[:notice] = "Series details updated successfully"
      redirect_to :action => :index
    rescue
      flash[:notice] = "There is problem to update series details"
       render :action => :edit
    end
  end
  
  def delete
    Series.find(params[:id]).destroy
    redirect_to :action => :index
  end
  
  def add_event
  end
  
  def remove_event
  end
  
end
