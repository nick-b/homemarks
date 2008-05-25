module RenderInvalidRecord
  
  def self.included(base)
    base.rescue_from(ActiveRecord::RecordInvalid, :with => :render_invalid_record)
  end
  
  protected
  
  def render_invalid_record(exception)
    record = exception.record
    respond_to do |format|
      format.html { render :action => (record.new_record? ? 'new' : 'edit') }
      format.js   { render :json => record.errors.full_messages, :status => :unprocessable_entity, :content_type => 'application/json' }
      format.xml  { render :xml => record.errors.full_messages,  :status => :unprocessable_entity }
      format.json { render :json => record.errors.full_messages, :status => :unprocessable_entity }
    end
  end
  
end

