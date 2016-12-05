command: """
  if [ ! -e kawase.sh ]; then
    "$PWD/kawase.widget/kawase.sh"
  else
    "$PWD/kawase.sh"
  fi
"""

#source $HOME/.b &> /dev/null && $HOME/Reference/C/coding/ubersicht/ubersicht.coffee

# the refresh frequency in milliseconds
# defaulting to a bit over 1 min.
refreshFrequency: 100520

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
# <p>#{output}</p>
render: (output) -> """
<table>
  <tr>
    <td>USD/JPY</td>
    <td><div id="usdjpy">loading...</div></td>
  </tr>
  <tr>
    <td>EUR/JPY</td>
    <td><div id="eurjpy">loading...</div></td>
  </tr>
  <tr>
    <td>GBP/JPY</td>
    <td><div id="gbpjpy">loading...</div></td>
  </tr>
</table>

"""

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

      # ==========================
      # ==== function to conditionally alter DOM and populate value
      
      compare=(latest,previous,id,content)->
        default_colour="#7eFFFF"
        
        set_colour = (colour) ->
          $(domEl).find(id).text(content).css('color',colour)

        # settimeout usage
        # http://stackoverflow.com/questions/5600351/javascript-change-css-color-for-5-seconds
        # https://evanhahn.com/smoothing-out-settimeout-in-coffeescript/
        run_delayed_set = (colour) ->
          setTimeout (-> set_colour(colour)), 50
          setTimeout (-> set_colour(default_colour)), 7000
           
        if latest < previous
          #$(domEl).find(id).text(content).css('color','red')
          run_delayed_set('red')
          #setTimeout($(domEl).find(id).text(content).css('color',default_colour), 5000)
          #console.log("set colour ran")
          #run_delayed_set()          
        else if latest > previous
          run_delayed_set('green')
        else
          $(domEl).find(id).text(content)
      # =======================

      # ============================
      compare(latest_num[0],previous_num[0],"#usdjpy",latest_num[0])
      compare(latest_num[1],previous_num[1],"#eurjpy",latest_num[1])
      compare(latest_num[2],previous_num[2],"#gbpjpy",latest_num[2])
      # =============================

      #time= (new Date).getTime();
      
style: """
  @font-face
    font-family: 'hack'
    src: url('assets/hack.ttf')
  // https://css-tricks.com/snippets/css/using-font-face/
  // how to use font available in directory
  
  color: #7eFFFF
  font-family: Melno regular, hack, Helvetica Neue
  font-weight: 100
  font-size: 15px
  top: 4%
  left: 2%

  table
    border-collapse: collapse
    border-spacing: 3px
    
  table td, table th 
    border: 1px solid #7eFFFF
    //#E6E6E6
    
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

  table tr td:last-child,
    border-right:0
    border-left:0

  table td
    padding-left:5px
    padding-right:5px
"""
