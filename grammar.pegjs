// grammar

start 
    = tags:tag* { return tags.join('') }

tag 
    =
    left_brace 
    tag:tag_id comma
    self_closing:self_closing
    attributes:attributes?
    content:content?
    right_brace
    { 
        let attribuesAvailable = attributes && attributes.length;
    	return `<${tag}${attribuesAvailable ? ' ' : ''}${attribuesAvailable ? attributes.map(x => `${x.key}="${x.value}"`).join(' ') : ''}${self_closing ? '/>' : '>' + content + '</' + tag + '>'}` 
    }
    
tag_id
    = hash id:alpha_numeric { return id }
    
self_closing
	= quotation "self_closing" quotation colon bool:boolean comma? { return bool; }
    
attributes
	= attributes:attr_list comma? { return attributes; }

attr_list 
    = 
    left_angle
    attributes:(
        head:key_value
        tail:(comma key_value:key_value { return key_value; })*
        { return [head].concat(tail); }
    )?
    right_angle
    { return attributes ? attributes : []; } 

content
	= quotation "content" quotation colon content:inner_content { return content; }

inner_content 
    = left_bracket
    content:(
        head:(tag / string)
        tail:(comma tag_str:(tag / string) { return tag_str; })*
        { return [head].concat(tail); }
    )?
    right_bracket
    { return content ? content.join('') : []; } 

key_value
    = key:string colon value:string { return {key, value}; }

string 
     = quotation str:chars quotation { return str; }
  
chars
	= chars:[^\0-\x1F\x22\x5C]* { return chars.join(""); }

numeric
    = minus? integer float? { return parseFloat(text()); }

float
    = dot integer

integer 
    = digit*

alpha_numeric
    = chars:[a-zA-Z0-9]i* { return chars.join(""); }

boolean 
	= true / false



// tokens

false = "false" { return false; }
true = "true" { return true; }

minus = "-"
plus = "+"

digit = [0-9]
letter = [a-z]i

colon = _ ":" _
quotation = _ '"' _
comma = _ "," _
dot = "."

left_brace = _ "{" _
right_brace = _ "}" _
left_bracket = _ "[" _
right_bracket = _ "]" _
left_angle = _ "<" _
right_angle = _ ">" _

hash = "#"

_ "whitespace"
  = [ \t\n\r]*