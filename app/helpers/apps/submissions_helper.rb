module Apps::SubmissionsHelper
  def render_csv
    CSV.generate do |csv| 
      
      pages = JSON.parse @submissions.first.construct.content
      
      columns = []
      columns << "Response" << "Form" << "Responder" << "Created" << "Submitted"
      
      column_headings = []
      pages.each do |page, page_contents|
        page_contents.each do |page_content|
          page_content.each do |item_type, properties|
            columns <<  properties['label'] unless item_type == 'page_content'
            columns << "#{properties['label']} [Other]" if properties['other']
          end
        end
      end
     
      csv << columns
      
      @submissions.each do |submission|
        row = []
        row << submission.id << submission.construct.name << submission.created_by.name << submission.created_at.to_formatted_s(:short) << submission.updated_at.to_formatted_s(:short)
        
        response = JSON.parse submission.content        
        response.each do |page, page_contents|
          page_contents.each do |page_content|
             page_content.each do |item_type, properties|
               if item_type == 'additional_options'
                  row << properties['other']
               else
                  if properties.kind_of?(Array) and properties.count < 2
                    if properties.count == 0
                      
                    end
                    if properties.count == 1
                      row << properties[0]
                    end
                  else
                    row << properties  
                  end
                  
               end
            end
          end
        end
        
        csv << row
      end
    end
  end
end
