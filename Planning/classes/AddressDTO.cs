
public class Address
{
    public string StreetAddress { get; set; }
    public City City { get; set; }
    public PostalCode PostalCode { get; set; }
    public Region { get; set; }
    public Country Country { get; set; }
}

public class CustomerAddressList : List<Address>
{

}
