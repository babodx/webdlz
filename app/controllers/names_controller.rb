class NamesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_admin, :except => [:index, :show]
  #load_and_authorize_resource :class => Record
  def index
    @user = current_user
    @allzones, @alphaParams = Zonename.all.alpha_paginate(params[:letter]){|zone| zone.name}

    @zones = @user.zonenames.order(:name)
    #@allzones = Zonename.where("user_id != ?", @user.id).order(:name).paginate(:page => params[:page])
    ###@allzones = Zonename.order(:name).paginate(:page => params[:page])
  end

  def new
    @user = current_user
  end

  def edit
    @user = current_user
    @zone = @user.zonenames.find(params[:id])
    @records = @zone.ns_records
    @a_records = @zone.a_records
    @soa_record = @zone.soa_record
    @ns_records = @zone.ns_records
    @mx_records = @zone.mx_records
    @aaaa_records = @zone.aaaa_records
    @cname_records = @zone.cname_records
    @ptr_records = @zone.ptr_records
    @txt_records = @zone.txt_records
  end

  def create
    @user = current_user
    @zone = @user.zonenames.create(:name => params[:rec][:name].downcase, :last_edit_user_id => @user.id)
    if @zone.save
      #@user.zonenames << @zone
      @nameserver = Nameserver.find(:all, :order => 'priority')
      #@nameservers = Nameserver.all
      @ns = @nameserver.blank? ? 'ns.molot.ru' : @nameserver.first.name
      @zone.create_soa_record(:zone => params[:rec][:name], :ttl => params[:rec][:ttl], :resp_person => "postmaster@molot.ru", :refresh => '1200', :retry => '3600', :expire => '604800', :minimum => '38400', :host => '@', :data => @ns)
      #@nameservers.each do
      #end
      if @zone.soa_record.save
        flash[:notice] = t('zona.created_successfull')
        redirect_to name_path(@zone)
      else
        @zone.soa_record.errors.each do |attr,message|
          flash[:error] = message
          redirect_to :back and return
        end
      end
    else
      @zone.errors.each do |attr,message|
        flash[:error] = message
      end
      redirect_to :back and return
    end
  end

  def update
    @user = current_user
    @zone = @user.zonenames.find(params[:id])
    @zone.name = params[:rec][:name]
    @soa_record = @zone.soa_record
    @soa_record.ttl = params[:rec][:ttl]
    @records = @zone.records
    @records.each do |z|
      #z.zone = params[:rec][:name]
      #z.save!
    end
    if @zone.save! && @soa_record.save!
      flash[:notice] = t('zona.updated')
      redirect_to name_path @zone
    else
      flash[:error] = t('zona.not_updated')
      redirect_to :back
    end
  end

  def show
    @user = current_user
    @zone = @user.zonenames.find(params[:id])
    @records = @zone.records
    @a_records = @zone.a_records
    @soa_record = @zone.soa_record
    @ns_records = @zone.ns_records
    @mx_records = @zone.mx_records
    @ptr_records = @zone.ptr_records
    @txt_records = @zone.txt_records
    @aaaa_records = @zone.aaaa_records
    @cname_records = @zone.cname_records
    @disabled_records = @zone.disabled_records
  end

  def destroy
    @user = current_user
    @zone = @user.zonenames.find(params[:id])
    if @zone.destroy
      flash[:notice] = t(:record_deleted)
      redirect_to :back
    end
  end
private
  def check_admin
    raise PermissionDenied, "Permission denied" if current_user.roles(:name => 'admin').first.nil?
  end
end
