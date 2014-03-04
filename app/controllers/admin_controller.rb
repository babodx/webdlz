class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_admin
  def new
    @user = current_user
  end

  def edit
    @user = current_user
    @zone = Zonename.find(params[:id])
    @records = @zone.ns_records
    @a_records = @zone.a_records
    @soa_record = @zone.soa_record
    @ns_records = @zone.ns_records
    @mx_records = @zone.mx_records
    @txt_records = @zone.txt_records
    @ptr_records = @zone.ptr_records
    @cname_records = @zone.cname_records
    @aaaa_records = @zone.aaaa_records
  end

  def create
  end

  def update
    @user = current_user
    @zone = Zonename.find(params[:id])
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
      redirect_to admin_path @zone
    else
      flash[:error] = t('zona.not_updated')
      redirect_to :back
    end
  end

  def destroy
    @user = current_user
    @zone = Zonename.find(params[:id])
    if @zone.destroy
      flash[:notice] = t(:record_deleted)
      redirect_to :back
    end
  end

  def show
    @user = current_user
    @zone = Zonename.find(params[:id])
    @records = @zone.records
    @a_records = @zone.a_records
    @soa_record = @zone.soa_record
    @ns_records = @zone.ns_records
    @mx_records = @zone.mx_records
    @txt_records = @zone.txt_records
    @ptr_records = @zone.ptr_records
    @aaaa_records = @zone.aaaa_records
    @cname_records = @zone.cname_records
    @disabled_records = @zone.disabled_records
  end
private
  def check_admin
    raise PermissionDenied, "Permission denied" if current_user.roles(:name => 'admin').first.nil?
  end
end
