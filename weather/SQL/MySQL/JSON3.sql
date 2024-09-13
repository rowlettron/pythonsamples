CREATE TABLE t1(json_col JSON);

INSERT INTO t1 VALUES (
    '{ "people": [
        { "name":"John Smith",  "address":"780 Mission St, San Francisco, CA 94103"}, 
        { "name":"Sally Brown",  "address":"75 37th Ave S, St Cloud, MN 94103"}, 
        { "name":"John Johnson",  "address":"1262 Roosevelt Trail, Raymond, ME 04071"}
     ] }'
);

SELECT people.* 
FROM t1, 
     JSON_TABLE(json_col, '$.people[*]' COLUMNS (
                name VARCHAR(40)  PATH '$.name',
                address VARCHAR(100) PATH '$.address')
     ) people;
     
truncate table t1;

insert into t1 values (
'[
  {
    "father": "John",
    "mother": "Mary",
    "children": [
      {
        "age": 12,
        "name": "Eric"
      },
      {
        "age": 10,
        "name": "Beth"
      }
    ],
    "marriage_date": "2003-12-05"
  },
  {
    "father": "Paul",
    "mother": "Laura",
    "children": [
      {
        "age": 9,
        "name": "Sarah"
      },
      {
        "age": 3,
        "name": "Noah"
      },
      {
        "age": 1,
        "name": "Peter"
      }
    ]
  }
]'
);

select * from t1;

select a.*
from t1,
JSON_TABLE (json_col, '$[*]' COLUMNS (	
            id FOR ORDINALITY,
            father VARCHAR(30) PATH '$.father',
            married INTEGER EXISTS PATH '$.marriage_date',
            NESTED PATH '$.children[*]' COLUMNS (
              child_id FOR ORDINALITY,
              child VARCHAR(30) PATH '$.name',
              age INTEGER PATH '$.age') )	
) a;

