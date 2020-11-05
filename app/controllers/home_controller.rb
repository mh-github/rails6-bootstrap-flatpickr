# app/controllers/home_controller.rb
class HomeController < ApplicationController
    
    @@message1 = []
    @@message2 = []
    @@message3 = []
    @@message4 = []
    @@message5 = []

    def index

    end

    def is_valid_date? aDate
        if aDate
            y, m, d = aDate.split '-'
            date_one_valid = Date.valid_date? y.to_i, m.to_i, d.to_i
        end
    end

    def get_date_history aDate

        msg_arr = []
        url = "http://numbersapi.com/" + aDate[5..6] + "/" + aDate[8..9] + "/date"
        5.times do
            uri = URI.parse(url)
            response = Net::HTTP.get_response(uri)
            msg_arr << response.body
        end
        
        if msg_arr.length > 0
            header_str = msg_arr[0].split('in ')[0] + "in "
            msg_arr.each do |msg|
                msg.remove! msg.split('in ')[0] + 'in'
                msg = "  * " + msg
            end
            msg_arr.unshift header_str
        end

        return msg_arr.uniq
    end

    def get_year_history aDate

        msg_arr = []
        url = "http://numbersapi.com/" + aDate[0..3] + "/year"
        5.times do
            uri = URI.parse(url)
            response = Net::HTTP.get_response(uri)
            msg_arr << response.body
        end
        
        if msg_arr.length > 0
            header_str = msg_arr[0].split('that ')[0] + ' that'
            msg_arr.each do |msg|
                msg.remove! msg.split('that ')[0] + 'that'
            end
            msg_arr.unshift header_str
        end
           
        return msg_arr.uniq
    end

    def process_dates

        @@message1 = []
        @@message2 = []
        @@message3 = []
        @@message4 = []
        @@message5 = []
        date_one  = params[:first_date]
        date_two  = params[:second_date]

        date_one_valid = is_valid_date? date_one
        date_two_valid = is_valid_date? date_two

        if params[:commit] == "Hist"
            if date_one_valid
                @@message1 = get_date_history(date_one) 
                day = Date.strptime(date_one,'%Y-%m-%d').strftime("%A")
                @@message1.unshift "Date One #{date_one} is #{day}"

                @@message2 = get_year_history(date_one)

                
            end
            if date_two_valid
                if date_two[5..9] != date_one[5..9]
                    @@message3 = get_date_history(date_two)
                end
                day = Date.strptime(date_two,'%Y-%m-%d').strftime("%A")
                @@message3.unshift "Date Two #{date_two} is #{day}"

                if date_two[0..3] != date_one[0..3]
                    @@message4 = get_year_history(date_two)
                end
            end           
        end
        else if params[:commit] == "Diff"
            if date_one_valid && date_two_valid
                days = Date.strptime(date_one,'%Y-%m-%d') - Date.strptime(date_two,'%Y-%m-%d')

                @@message5 << "Dates entered are #{date_one} and #{date_two}"
                @@message5 << "Number of days between the two dates is #{days.to_i.abs}"
            else
                @@message5 << "Input two valid dates please."
            end
        end

        redirect_to action: :display
    end

    def display
        @message1 = @@message1
        @message2 = @@message2
        @message3 = @@message3
        @message4 = @@message4
        @message5 = @@message5
    end
end