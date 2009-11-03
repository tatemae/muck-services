class Muck::AggregationFeedsController < ApplicationController

  unloadable
  
  before_filter :login_required

  def destroy
    @aggregation_feed = AggregationFeed.find(params[:id]) rescue nil if params[:id] && params[:id].to_i > 0
    @aggregation_feed ||= AggregationFeed.find_by_feed_id_and_aggregation_id(params[:feed_id], params[:aggregation_id])
    @aggregation = @aggregation_feed.aggregation
    if has_aggregation_permission?
      @aggregation_feed.destroy
      respond_to do |format|
        message = I18n.t('muck.services.feed_remove')
        format.html do
          flash[:notice] = message
          redirect_to polymorphic_url([@aggregation.ownable, @aggregation])
        end
        format.json { render :json => { :success => true, :message => message }.as_json }
        format.xml  { head :ok }
      end
    end
  end

  protected
  
    def has_aggregation_permission?
      if !@aggregation.can_edit?(current_user)
        message = I18n.t('muck.services.cant_modify_aggregation')
        respond_to do |format|
          format.html do
            flash[:notice] = message
            redirect_to polymorphic_url([@aggregation.ownable, @aggregation])
          end
          format.js { render(:update) {|page| page.alert message} }
          format.json { render :json => { :success => false, :message => message }.as_json }
        end
      else
        true
      end
    end
  
end
