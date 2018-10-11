

## Example of Aggregation Model
```puml
@startuml

!define SEQUENCE (S , #AAAAAA ) Database Sequence
!define TABLE (T , #FFAAAA ) Database Table

class OrderItem  << TABLE >>
class Product  << TABLE >>
class Payment  << TABLE >>
class Order  << TABLE >>
{
}
class customer  << TABLE >>
{
    +name
}
class address  << TABLE >>
{
  street
  city
  state
  postcode
}
customer  -- "*" Order
Payment  "*" --*  Order
OrderItem "*" --*  Order
OrderItem "*" --  Product
customer  *--   "*" address : address
address  --*  Order  : shipping address
Payment  *-- address : billing address
@enduml
```


### 6 Rules of Thumb for MongoDB Schema Design
https://www.mongodb.com/blog/post/6-rules-of-thumb-for-mongodb-schema-design-part-1
https://www.mongodb.com/blog/post/6-rules-of-thumb-for-mongodb-schema-design-part-2


### NOSQL DATA MODELING TECHNIQUES
https://highlyscalable.wordpress.com/2012/03/01/nosql-data-modeling-techniques/

### Data Modeling Guidelines for NoSQL JSON Document Databases
https://mapr.com/blog/data-modeling-guidelines-nosql-json-document-databases/

### NoSQL Data Modeling
https://www.ebayinc.com/stories/blogs/tech/nosql-data-modeling/

### 
