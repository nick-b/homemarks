module RenderInvalidRecord
  
  def self.included(base)
    base.rescue_from(ActiveRecord::RecordInvalid, :with => :render_invalid_record)
  end
  
  protected
  
  def render_invalid_record(exception)
    record = exception.record
    record_instance_name = "@#{record.class.to_s.underscore}"
    instance_variable_set(record_instance_name, record) unless instance_variable_get(record_instance_name)
    respond_to do |format|
      format.html { render :action => (record.new_record? ? 'new' : 'edit') }
      format.js   { render :json => record.errors, :status => :unprocessable_entity, :content_type => 'application/json' }
      format.xml  { render :xml => record.errors, :status => :unprocessable_entity }
      format.json { render :json => record.errors, :status => :unprocessable_entity }
    end
  end
  
end

