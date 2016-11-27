command: """
  if [ ! -e kawase.sh ]; then
    "$PWD/kawase.widget/kawase.sh"
  else
    "$PWD/kawase.sh"
  fi
"""

#source $HOME/.b &> /dev/null && $HOME/Reference/C/coding/ubersicht/ubersicht.coffee

# the refresh frequency in milliseconds
refreshFrequency: 12100

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
# <p>#{output}</p>
render: (output) -> """
<table>
  <tr>
    <td>USDJPY</td>
    <td><div id="usdjpy">loading...</div></td>
  </tr>
  <tr>
    <td>EURJPY</td>
    <td><div id="eurjpy">loading...</div></td>
  </tr>
  <tr>
    <td>GBPJPY</td>
    <td><div id="gbpjpy">loading...</div></td>
  </tr>
</table>

"""

# afterRender: (output, domEl) ->
#   <div id="load">loading...</div>

update:(output,domEl) ->
  @run """
    if [ ! -e kawase.sh ]; then
      "$PWD/kawase.widget/kawase.sh"
    else
      "$PWD/kawase.sh"
    fi
  """, (err, output) ->
      extract_num =(x)-> parseFloat(x.split(" ")[1])
      #get_parse_curr=(arr,pos)-> extract_num(arr.split(",")[pos])
        
      data=output.split(":");
      previous=data[0].split(",")      
      latest=data[1].split(",")

      # both arrays currency are in the order of
      # USDJPY, EURJPY, GBPJPY
      latest_num = (extract_num(num) for num in latest)
      previous_num = (extract_num(num) for num in previous)
      #console.log(latest_num)
      
      compare=(latest,previous,id,content)->
        if latest < previous
          $(domEl).find(id).text(content).css('color','red')
        else if latest > previous
          $(domEl).find(id).text(content).css('color','green')
        else
          $(domEl).find(id).text(content)#.css({ 'color': 'red'})
          #$(domEl).find("#gbpjpy").text(l_gbp).css({ 'color': 'red', 'font-size': '150%' })

      compare(latest_num[0],previous_num[0],"#usdjpy",latest_num[0])
      compare(latest_num[1],previous_num[1],"#eurjpy",latest_num[1])
      compare(latest_num[2],previous_num[2],"#gbpjpy",latest_num[2])
      #l_gbp = get_parse_curr(latest,1)
      
      # gbpjpy_arr = data[0]
      # usdjpy_arr = data[1]
      # eurjpy_arr = data[2]
      # gbpjpy_p = extract(gbpjpy_arr)
      
      #dataIn = parseFloat(data[0]);
      #dataOut = parseFloat(data[1]);
      #console.log(p_gbp)
      #console.log(l_gbp)
      
      # console.log(gbpjpy)
      # console.log(usdjpy)
      #console.log(gbpjpy_p)
      #i=-99;
      time= (new Date).getTime();
      #console.log(time)
      #timeData = time + i * 10000;
      
      
style: """
  color: #7eFFFF
  font-family: Helvetica Neue
  font-weight: 100
  font-size: 25px
  top: 4%
  left: 2%

  table
    border-collapse: collapse
    border-spacing: 3px
    
  table td, table th 
    border: 1px solid #7eFFFF
   // #D3D3D3

  table tr:first-child td 
    border-top: 0

  table tr:last-child td 
    border-bottom: 0

  table tr td:first-child,
  table tr th:first-child 
    border-left: 0

  table tr td:last-child,
  table tr th:last-child 
    border-right: 0

  table tr td
    border-right:0
    border-left:0
  
  table td
    padding-left:5px
    padding-right:5px
"""
