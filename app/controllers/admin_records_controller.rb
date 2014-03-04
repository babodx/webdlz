class AdminRecordsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_admin
  def show
  end

  def create
    @zone = Zonename.find(params[:admin_id])
    redirect_to :back and return if !params[:record]
    raise CustomExceptions::NotEnoughParams if !params[:record][:host] || !params[:record][:data]
    host = !params[:record][:host].blank? ? params[:record][:host] : '@'
    @zone.a_records.create(:zone => @zone.name, :host => host, :data => params[:record][:data], :ttl => @zone.soa_record.ttl) if params[:record][:record_type] == "A"
    @zone.mx_records.create(:zone => @zone.name, :host => host, :data => params[:record][:data], :mx_priority => params[:record][:mx_priority], :ttl => @zone.soa_record.ttl) if params[:record][:record_type] == "MX"
    @zone.cname_records.create(:zone => @zone.name, :host => host, :data => params[:record][:data], :ttl => @zone.soa_record.ttl) if params[:record][:record_type] == "CNAME"
    @zone.txt_records.create(:zone => @zone.name, :host => host, :data => params[:record][:data], :ttl => @zone.soa_record.ttl) if params[:record][:record_type] == "TXT"
    @zone.ptr_records.create(:zone => @zone.name, :host => host, :data => params[:record][:data], :ttl => @zone.soa_record.ttl) if params[:record][:record_type] == "PTR"
    @zone.ns_records.create(:zone => @zone.name, :host => host, :data => params[:record][:data], :ttl => @zone.soa_record.ttl) if params[:record][:record_type] == "NS"
    if @zone.save
      flash[:notice] == t(:record_created_successfull)
      redirect_to admin_path(@zone)
    else
      @zone.errors.each do |attr,mes|
        flash[:error] = mes
      end
      redirect_to :back
    end
  end

  def update
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    @rec = @zone.records.find(params[:id])
    @rec.host = params[:record][:host]
    @rec.data = params[:record][:data]
    @rec.mx_priority = params[:record][:mx_priority]
    if @rec.save
      flash[:notice] = t('record.updated_successfully')
      redirect_to admin_path(@zone) and return
    else
      @rec.errors.each do |attr,mes|
        flash[:error] = mes
        redirect_to :back and return
      end
    end
  end
  def edit
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    @record = @zone.records.find(params[:id])
    @a_records = @zone.a_records
    @soa_record = @zone.soa_record
    @ns_records = @zone.ns_records
    @mx_records = @zone.mx_records
    @txt_records = @zone.txt_records
  end
  def disable
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    @record = @zone.records.find(params[:admin_record_id])
    @disabled_record = DisabledRecord.new(:zone => @record.zone, :host => @record.host, :ttl => @record.ttl,
                                          :mx_priority => @record.mx_priority, :data => @record.data,
                                          :resp_person => @record.resp_person, :serial => @record.serial,
                                          :refresh => @record.refresh, :retry => @record.retry, :expire => @record.expire,
                                          :minimum => @record.minimum, :record_type => @record.record_type,
                                          :user_id => @record.user_id, :last_edit_time => Time.now,
                                          :created_time => @record.created_time, :zonename_id => @record.zonename_id
    )
    if @disabled_record.save
      @record.destroy
      flash[:notice] = t(:record_temporary_disabled)
      redirect_to :back
    else
      @disabled_record.errors.each do |attr,error|
        flash[:error] = error
        redirect_to :back
      end
    end
  end

  def activate
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    @record = @zone.disabled_records.find(params[:admin_record_id])
    @actrec = Record.new(:zone => @record.zone, :host => @record.host, :ttl => @record.ttl,
                         :mx_priority => @record.mx_priority, :data => @record.data,
                         :resp_person => @record.resp_person, :serial => @record.serial,
                         :refresh => @record.refresh, :retry => @record.retry, :expire => @record.expire,
                         :minimum => @record.minimum, :record_type => @record.record_type,
                         :user_id => @record.user_id, :last_edit_time => Time.now,
                         :created_time => @record.created_time, :zonename_id => @record.zonename_id)
    if @actrec.save
      @record.destroy
      flash[:notice] = t(:record_activated)
      redirect_to :back
    else
      @actrec.errors.each do |attr,error|
        flash[:error] = error
        redirect_to :back
      end
    end
  end

  def new
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    @rec = @zone.records.new
  end

  def destroy
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    @record = @zone.records.find(params[:id])
    if @record.destroy
      flash[:notice] = t(:record_deleted)
      redirect_to admin_path(@zone)
    end
  end
  def destroy_disabled
    @user = current_user
    @zone = Zonename.find(params[:admin_id])
    rec = @zone.disabled_records.find(params[:admin_record_id])
    if rec.destroy
      flash[:notice] = t(:record_destroyed)
      redirect_to :back
    end
  end
  private
  def check_admin
    raise PermissionDenied, "Permission denied" if current_user.roles(:name => 'admin').first.nil?
  end
end
