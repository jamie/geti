class Geti::AppClient < Geti::Client
  MERCHANT_OWNERSHIP = {
    "1" => "Corporation",
    "2" => "Partnership",
    "3" => "Sole Proprietorship"
  }
  MERCHANT_SERVICE_TYPES = {
    "GOLD" => "Service_Level_Used_For_Guaranteed_ACHed_Transaction_Processing",
    "SILVER" => "Service_Level_Used_For_Non-Guaranteed_ACHed_Transaction_Processing",
    "BRONZE" => "Service_Level_Used_For_Non-Guaranteed_Verification-Only_Processing",
    "TRADITIONAL" => "Service_Level_Used_For_Guaranteed_Verification-Only_Processing",
  }
  MERCHANT_TYPES = {
    "1" => "Antique_Shops",
    "2" => "Applicances_Electrical_Repair",
    "3" => "Art_Dealers_Art_Galleries",
    "4" => "Artists_Supplies",
    "5" => "Auto_Dealers_New_All_Depts",
    "6" => "Auto_And_Home_Supplies",
    "7" => "Auto_Parking_Lots_Garages",
    "8" => "Auto_Parts_Stores",
    "9" => "Auto_Rentals_And_Leasing",
    "10" => "Auto_Paint_Top_Body",
    "11" => "Auto_Repair",
    "12" => "Auto_Sales_Used_Only",
    "13" => "Automotive_Glass",
    "14" => "Automotive_Tire_Stores",
    "16" => "Bakeries",
    "17" => "Barber_Beauty_Shops",
    "18" => "Bicycle_Sales_Service",
    "19" => "Billiards_Tables_And_Supplies",
    "20" => "Boats_Dealers_All",
    "21" => "Boats_Dealers_Parts_Service",
    "22" => "Book_Stores",
    "23" => "Bridal_Shops_And_Accessories",
    "24" => "Building_Materials",
    "25" => "Camera_And_Photo_Supplies",
    "26" => "Car_Stero_Cellular_Phones_And_Pagers",
    "27" => "Car_Washes",
    "28" => "Card_Gift_Shops",
    "29" => "Cigar_Stores",
    "30" => "Clothing",
    "31" => "Computers_And_Software_Retail_Only",
    "32" => "Contractors",
    "33" => "Convenience_Stores",
    "34" => "Cosmetic_Beauty_Supplies",
    "35" => "Department_Stores",
    "36" => "Drug_Stores_And_Pharmacies",
    "37" => "Dry_Cleaners",
    "38" => "Electrical_Contractors",
    "39" => "Eyeglass_Stores",
    "40" => "Fabric_Stores",
    "41" => "Floor_Covering",
    "42" => "Florists",
    "43" => "Funeral_Homes_Crematories",
    "44" => "Furniture_Stores",
    "45" => "Garden_Lawn_Supply",
    "46" => "Gas_Stations",
    "47" => "Glass_Stores",
    "48" => "Golf_Course_Pro_Shop",
    "49" => "Grocery_Supermarket",
    "50" => "Hardware_Stores",
    "51" => "Health_Food_Stores",
    "52" => "Heating_Air",
    "53" => "Heavy_Equipment_Truck_Repair",
    "54" => "Heavy_Equipment_Rentals",
    "55" => "Heavy_Equipment_Sales",
    "56" => "Hospitals_Clinics",
    "57" => "Hotels_Motels",
    "58" => "Housewares",
    "59" => "Jewelry_Sales",
    "60" => "Liquor_Stores",
    "61" => "Locksmiths",
    "62" => "Maintenance_Cleaning_Service",
    "63" => "Motorcycle_Dealers_All",
    "64" => "Motorhome_Dealers",
    "65" => "Moving_Storage_Delivery",
    "66" => "Muffler_Shops",
    "67" => "Music_Stores_Instruments",
    "68" => "Office_Supply",
    "69" => "Oil_Change_Shop",
    "70" => "Optometrists",
    "71" => "Pet_Shops",
    "72" => "Physicians",
    "73" => "Pizza_Parlors",
    "74" => "Postal_Shipping_Services",
    "75" => "Print_Shops",
    "76" => "Record_Shops",
    "77" => "Rental_Trucks_And_Trailers",
    "78" => "Restaurants",
    "79" => "Salvage_And_Wrecking",
    "80" => "Secondhand_Stores",
    "81" => "Sporting_Goods_Stores",
    "82" => "Stereo_Sales_Radio_Sales",
    "83" => "Swimming_Pool_Sales",
    "84" => "Tack_Shop_Equestrian_Supplies",
    "85" => "Towing_Services",
    "87" => "Transmission_Repair",
    "88" => "Vacuum_Cleaner_Sales",
    "89" => "Veterinary_Clinics_Hospitals",
    "90" => "Video_Stores",
    "91" => "Childcare_Daycare_Preschool",
    "92" => "Meat_And_Seafood",
    "93" => "Dental",
    "94" => "Plumbing_Contractors",
    "95" => "Employment_Agency",
    "96" => "Sign_Shops",
    "97" => "Carpentry",
    "98" => "Physical_Therapy",
    "99" => "Motorcycle_Repair",
    "100" => "Nail_Products_Manicures",
    "101" => "Meetings_Events_Banquets_Parties",
    "102" => "Accounting_Firms",
    "103" => "Uniforms",
    "104" => "Bar_Lounge",
    "105" => "Tanning_Salons",
    "106" => "Hospital_Equipment_Supplies",
    "107" => "Metal_Fabricators",
    "108" => "Transportation_Services",
    "109" => "Fitness_Spa_Gym",
    "110" => "Pawn_Shop",
    "111" => "Bowling_Alley",
    "112" => "Legal_Services",
    "113" => "Religious_Organizations",
    "115" => "School",
    "116" => "Pet_Grooming",
    "117" => "Electronics_Electronic_Repair",
    "118" => "Travel_Agency",
    "119" => "Tatto_Body_Piercing_Parlor",
    "120" => "Insurance_Agency",
    "121" => "Recreational",
    "122" => "Real_Estate",
    "123" => "Trailer_Sales",
    "124" => "Exterminators",
    "125" => "Party_Supply_Store",
    "126" => "Entertainment",
    "127" => "Bail_Bonds",
    "128" => "Hobbie_Shop",
    "129" => "Craft_Shop",
    "130" => "Photo_Studio",
    "131" => "Marina",
    "132" => "Security_And_Alarms",
    "133" => "Auto_Detailing",
    "134" => "Furniture_Rental",
    "135" => "General_Merchandise",
    "136" => "Leather_Goods_Lugguage",
    "137" => "Waste_Removal",
    "138" => "Tool_Rentals",
    "139" => "Other",
    "140" => "Casino_Gambling"
  }

  def board_merchant_ach(application)
    response = soap_request("BoardCertificationMerchant_ACH", "board_certification_merchant_ach") do |xml|
      data_packet(xml, application)
    end
    # success_response = {:status=>"Approved",
    #    :message=>
    #     "1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nCogsley's Cogs (ISO ID: 9999, CrossRef: 123456, Status: AppApprovedandActivated)\n\n",
    #    :app_data=>
    #     {:merchant=>
    #       {:@name=>"Cogsley's Cogs",
    #        :@active=>"1",
    #        :@type=>"Merchant",
    #        :@cross_ref_id=>"123456",
    #        :@id=>"20",
    #        :location=>
    #         {:terminal=>
    #           {:@manual_entry=>"N",
    #            :@name=>"Lipman Nurit 3000-01 (111163) ",
    #            :@active=>"1",
    #            :@type=>"Terminal",
    #            :@cross_ref_id=>"41680",
    #            :@id=>"111163",
    #            :@mid=>"101-111163-606"},
    #          :@name=>"Cogsley's Cogs ",
    #          :@active=>"1",
    #          :@ach_name=>"COGSLEYSCOGS",
    #          :@type=>"Location",
    #          :@cross_ref_id=>"123456",
    #          :@id=>"31"},
    #        :poc1=>
    #         {:@password=>"UGPRDGIX",
    #          :@user_name=>"CCogsley",
    #          :@last_name=>"Cogsley",
    #          :@first_name=>"Carl"}}},
    #    :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
    #    :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
    #    :validation_message=>{:result=>"Passed", :schema_file_path=>nil}}
    # error_response = {:"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
    #   :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
    #   :validation_message=>
    #    {:result=>"Failed",
    #     :schema_file_path=>
    #      "http://demo.eftchecks.com/WebServices/schemas/app/NewMerchApp_ACH.xsd",
    #     :validation_error=>
    #      [{:@line_number=>"1",
    #        :severity=>"Error",
    #        :message=>"The 'pocAddress1' attribute is not declared.",
    #        :@line_position=>"1193"},
    #       {:@line_number=>"1",
    #        :severity=>"Error",
    #        :message=>"The required attribute 'pocAddress' is missing.",
    #        :@line_position=>"1020"}]}}
    # repeat_response = {:status=>"Pending",
    #   :message=>
    #    "1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nCogsley's Cogs (ISO ID: 9999, CrossRef: 123456, Status: PendingInput)\n\n",
    #   :validation_message=>{:result=>"Passed", :schema_file_path=>nil},
    #   :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
    #   :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
    #   :app_data=>{:merchant=>{:@id=>"21"}}}
    # 
    response[:response]
  end

  def data_packet(xml, opts)
    xml.Envelope do
      xml.Body :FileName => "261407_28_May_2009_12_05_00_590.xml", :FileDate => Time.now.iso8601 do
        xml.NewMerchant({
          :isoID              => "9999",
          :merchCrossRefID    => opts[:id],
          :merchName          => opts[:name], # Legal Name
          :merchTypeID        => MERCHANT_TYPES.index(opts[:industry]), # "Type of goods sold"
          :merchServiceType   => "GOLD",
          # TODO: Tax ID
          :merchAddress1      => opts[:address], # TODO: Is this mailing or DBA address?
          :merchCity          => opts[:city],
          :merchState         => opts[:state],
          :merchZip           => opts[:zip],
          :merchPhone         => opts[:phone],
          # TODO: Fax number
          :merchAchFlatFee    => "",
          :merchNonAchFlatFee => "",
          :merchPercentFee    => "",
          :merchComments      => taxpayer_info(opts),
          :merchReturnFee     => "",
          # TODO: Web Address
          # TODO: Email address
        }) do
          xml.BusinessInfo({
            :merchOwnership => MERCHANT_OWNERSHIP.index(opts[:business_type]),
            :merchAvgCheckAmount => opts[:average_amount],
            :merchMaxCheckAmount => opts[:max_amount],
            :merchTotalTimeInBusiness => opts[:days_in_business],
          })
          xml.NewLocation({
            :locName           => opts[:name], # DBA name?
            :locCrossRefID     => opts[:id],
            :locAddress1       => opts[:physical_address], # TODO: Is this mailing or DBA address?
            :locCity           => opts[:physical_city],
            :locState          => opts[:physical_state],
            :locZip            => opts[:physical_zip],
            :locPhone          => opts[:physical_phone],
            :locStatementFee   => "0",
            :locMinimumFee     => "0",
            :locFeesRoutingNum => opts[:routing_number],
            :locFeesAccountNum => opts[:account_number],
            # TODO: Days in operation at this location?
          }) do
            xml.Statement({
              :locStatementAttn     => opts[:contact_name], # TODO: Where does title/alternate go?
              :locStatementAddress1 => opts[:physical_address], # TODO: Is this mailing or DBA address?
              :locStatementCity     => opts[:physical_city],
              :locStatementState    => opts[:physical_state],
              :locStatementZip      => opts[:physical_zip],
            })
            xml.NewPOC({
              :pocFirstName => opts[:principal_first_name],
              :pocLastName  => opts[:principal_last_name],
              :pocTitle     => opts[:principal_title],
              # TODO: % Ownership
              :pocAddress   => opts[:principal_address], # TODO: Is this mailing or DBA address?
              :pocCity      => opts[:principal_city],
              :pocState     => opts[:principal_state],
              :pocZip       => opts[:principal_zip],
              :pocDOB       => opts[:principal_dob], # Y-M-D
              :pocSSN       => opts[:principal_ssn], # 9-digits?
              # TODO: Driver's License

              :pocPrimary => "1",
              :pocComments => "",
            })
            xml.NewTerminal({
              :termCrossRefID       => opts[:id],
              :termCheckLimit       => "500.00",
              :termPeripheral       => "63",
              :termTypeID           => "16",
              :termVerificationOnly => "0",
            })
            # More NewTerminal entries
          end
        end
      end
    end
  end

  def service_address
    "https://demo.eftchecks.com/webservices/AppGateway.asmx?WSDL"
  end

  def soap_header
    { "RemoteAccessHeader" => {
        "UserName" => @user,
        "Password" => @pass
      },
      :attributes! => { "RemoteAccessHeader" => {"xmlns"=>"http://tempuri.org/GETI.eMagnus.WebServices/AppGateway"}}
    }
  end

  def taxpayer_info(opts)
    "Tax Info: %s - %d" % [opts[:taxpayer_name], opts[:taxpayer_id]]
  end
end
