class API::V1::Present < Grape::Validations::Validator
  def validate_param!(attr_name, params)
    unless params[attr_name].present?
      raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "can't be blank"
    end
  end
end

class API::V1::Applicants < Grape::API
  include API::V1::Defaults


  resource :applicants do
    helpers do
      params :applicant do
        requires :applicant, type: Hash do
          requires :first_name, type: String, present: true, desc: 'First name.'
          requires :last_name, type: String, present: true, desc: 'Last name'
          requires :phone, type: String, present: true, desc: 'Phone.'
          requires :address, type: String, present: true, desc: 'Address.'
          requires :specialization, type: String, present: true, desc: 'Specialization.'
          requires :degree, type: String, present: true, desc: 'Degree.'
        end
      end

      def safe_params
        @safe_params ||= declared(params, include_missing: false)[:applicant]
      end
    end

    desc 'Return all applicants.'
    get do
      present :applicants, Applicant.all
    end

    desc 'Create an applicant.'
    params do
      use :applicant
    end
    post do
      present :applicant, Applicant.create!(safe_params)
    end

    route_param :id, type: Integer, desc: 'Applicant id.' do
      desc 'Get an applicant by id.'
      get do
        present :applicant, Applicant.find(params[:id])
      end

      desc 'Update an applicant.'
      params do
        use :applicant
      end
      put do
        applicant = Applicant.find(params[:id])
        applicant.update! safe_params

        present :applicant, applicant
      end

      desc 'Delete an applicant.'
      delete do
        present :applicant, Applicant.find(params[:id]).destroy
      end
    end
  end
end
