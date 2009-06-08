require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class InvoiceTest < Test::Unit::TestCase

  def setup_resources
    @invoice_xml =  {:id => 1, :number => "100"}.to_xml(:root => "invoice")
    @invoices    = [{:id => 1, :number => "100"}].to_xml(:root => "invoices")
  end

  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/invoices.xml",           {}, @invoices
      mock.get    "/invoices/1.xml",         {}, @invoice_xml
      mock.post   "/invoices.xml",           {}, @invoice_xml,  201, "Location" => "/invoices/5.xml"
      mock.put    "/invoices/1.xml",         {}, nil,           200
      mock.delete "/invoices/1.xml",         {}, nil,           200
    end
  end

  context "Invoice CRUD actions -- " do
    setup do
      setup_resources
      mock_responses
    end

    should "get index" do
      Harvest::Resources::Invoice.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/invoices.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end

    should "get a single invoice" do
      Harvest::Resources::Invoice.find(1)
      expected_request = ActiveResource::Request.new(:get, "/invoices/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end

    should "create a new invoice" do
      invoice = Harvest::Resources::Invoice.new(:number => "200")
      invoice.save
      expected_request = ActiveResource::Request.new(:post, "/invoices.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end

    should "update an existing invoice" do
      invoice = Harvest::Resources::Invoice.find(1)
      invoice.number = "200"
      invoice.save
      expected_request = ActiveResource::Request.new(:put, "/invoices/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end

    should "delete an existing invoice" do
      Harvest::Resources::Invoice.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/invoices/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end

  end

  context "finding an invoice by number" do
    setup do
      setup_resources
      mock_responses
    end

    should "find an invoice with the given number" do
      i = Harvest::Resources::Invoice.find_by_number('100')
      expected_request = ActiveResource::Request.new(:get, "/invoices.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
      assert_kind_of(Harvest::Resources::Invoice, i)
      assert i.number == '100'
    end

    should "return nil if no invoice found" do
      i = Harvest::Resources::Invoice.find_by_number('200')
      expected_request = ActiveResource::Request.new(:get, "/invoices.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
      assert i.nil?
    end

    should "still find the invoice if asked for with an integer" do
      i = Harvest::Resources::Invoice.find_by_number(100)
      expected_request = ActiveResource::Request.new(:get, "/invoices.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
      assert_kind_of(Harvest::Resources::Invoice, i)
      assert i.number == '100'
    end
  end

  context "parsing csv formatted line items" do
    setup do
      @csv = "kind,description,quantity,unit_price,amount,taxed,taxed2,project_id\nService,[code] Client - 2009-05-17 - Admin / John Doe: my description for item 1,2.00,10.00,20.00,false,false,1001\nService,\"[code] Client - 2009-05-17 - Admin / Joe Schmoe: my description for item 2\",0.50,20.00,10.0,false,false,1002\n"
      @invoice = Harvest::Resources::Invoice.new
      @invoice.expects(:csv_line_items).returns(@csv)
    end

    should "return an array of hashes indexed by header with expected values" do
      line_items = @invoice.parsed_line_items
      headers = %w(kind description quantity unit_price amount taxed taxed2 project_id).sort

      assert_kind_of Array, line_items
      line_items.each do |line_item|
        assert_kind_of Hash, line_item
        assert_equal headers, line_item.keys.sort
      end
      assert_equal "2.00", line_items[0]['quantity']
      assert_equal "0.50", line_items[1]['quantity']
    end
  end
end
