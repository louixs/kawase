command: """
  if [ ! -e kawase.sh ]; then
    "$PWD/kawase.widget/kawase.sh"
  else
    "$PWD/kawase.sh"
  fi
"""

# update frequency
# lowest possible was a bit over 3 min. (300520)
# google seem to block if you do this too frequently so be careful not to make this too often
 
refreshFrequency: '10m'

# render gets called after the shell command has executed. The command's output
# is passed in as a string. Whatever it returns will get rendered as HTML.
# <p>#{output}</p>
  
render: (output) -> """
<div id=kawase>
  <table>
    <tr>
      <td>USD/JPY</td>
      <td><div id="usdjpy"><img src="kawase.widget/assets/loading.gif" alt="loading..." height="20" width="20"></div></td>
    </tr>
    <tr>
      <td>EUR/JPY</td>
      <td><div id="eurjpy"><img src="kawase.widget/assets/loading.gif" alt="loading..." height="20" width="20"></div></td>
    </tr>
    <tr>
      <td>GBP/JPY</td>
      <td><div id="gbpjpy"><img src="kawase.widget/assets/loading.gif" alt="loading..." height="20" width="20"></div></td>
    </tr>
    <tr>
      <td>SGD/JPY</td>
      <td><div id="sgdjpy"><img src="kawase.widget/assets/loading.gif" alt="loading..." height="20" width="20"></div></td>
    </tr>      
  </table>
</div>
"""

update:(output,domEl) ->
  @run """
    if [ ! -e kawase.sh ]; then
      "$PWD/kawase.widget/kawase.sh"
    else
      "$PWD/kawase.sh"
    fi
  """, (err, output) ->
      show=(x)-> console.log x

      extract_num =(x)-> parseFloat(x.split(" ")[1])
      #get_parse_curr=(arr,pos)-> extract_num(arr.split(",")[pos])
      
      data=output.split(";");
      datetime=data[0].split(",")
      previous=data[0].split(",")      
      latest=data[1].split(",")

      # datetime
      previous_datetime = previous[0]
      latest_datetime = latest[0]
    
      # currency data
      # getting rid of datetime
      previous.splice(0,1)
      latest.splice(0,1)
      previous_curr = previous
      latest_curr = latest
      
      # both arrays currency are in the order of
      # USDJPY, EURJPY, GBPJPY
      latest_num = (extract_num(num) for num in latest_curr)
      previous_num = (extract_num(num) for num in previous_curr)

      # ==========================
      # ==== function to conditionally alter DOM and populate value      
      compare=(latest_curr,previous_curr,id,content)->
        default_colour="#6fc3df"
        
        set_colour = (colour) ->
          $(domEl).find(id).text(content).css('color',colour)

        # settimeout usage
        # http://stackoverflow.com/questions/5600351/javascript-change-css-color-for-5-seconds
        # https://evanhahn.com/smoothing-out-settimeout-in-coffeescript/
        run_delayed_set = (colour) ->
          setTimeout (-> set_colour(colour)), 200
          setTimeout (-> set_colour(default_colour)), 1000
           
        if latest_curr < previous_curr
          #$(domEl).find(id).text(content).css('color','red')
          run_delayed_set('red')
          #setTimeout($(domEl).find(id).text(content).css('color',default_colour), 5000)
          #console.log("set colour ran")
          #run_delayed_set()          
        else if latest_curr > previous_curr
          run_delayed_set('green')
        else
          $(domEl).find(id).text(content)
      # =======================

      # ============================
      compare(latest_num[0],previous_num[0],"#usdjpy",latest_num[0])
      compare(latest_num[1],previous_num[1],"#eurjpy",latest_num[1])
      compare(latest_num[2],previous_num[2],"#gbpjpy",latest_num[2])
      compare(latest_num[3],previous_num[3],"#sgdjpy",latest_num[3])      
      # =============================

      #time= (new Date).getTime();
      
style: """
  @font-face
    font-family: 'hack'
    src: url('assets/hack.ttf')
  // https://css-tricks.com/snippets/css/using-font-face/
  // how to use font available in directory
  
  color: #6fc3df
  font-family: Melno regular, hack, Helvetica Neue
  font-weight: 100
  font-size: 15px
  top: 1%
  left: 1%

  table
    border-collapse: collapse
    border-spacing: 3px
    
  table td, table th 
    border: 1px solid #6fc3df
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
