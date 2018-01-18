var previousColumn, radar;

radar = null;

previousColumn = 57;

this.hover = function(e, r) {
  if (e[0] !== void 0) {
    debugger;
  }
};

this.click = function(e, r) {
  var column;
  column = parseInt(((e.screenX - 137) / 16.9).toString());
  console.log(column);
  $("#dataNumber").html(key[column]);
  radar.data.datasets[1].data = radar.data.datasets[0].data;
  radar.data.datasets[1].label = radar.data.datasets[0].label;
  radar.data.datasets[0].label = key[column];
  radar.data.datasets[0].data = [numbers[column], times[column], distances[column], away[column]];
  radar.options.title.text = 'Comparative graph between ' + key[column] + ' and ' + key[previousColumn];
  radar.update();
  $("#datasetblue").html($("#datasetred").html());
  $("#datasetred").html(key[column]);
  $("#numberblue").html($("#numberred").html());
  $("#numberred").html(parseInt(numbers[column].toString()) + " %");
  $("#awayblue").html($("#awayred").html());
  $("#awayred").html(parseInt(away[column].toString()) + " %");
  $("#timeblue").html($("#timered").html());
  $("#timered").html(parseInt(times[column].toString()) + " %");
  $("#distanceblue").html($("#distancered").html());
  $("#distancered").html(parseInt(distances[column].toString()) + " %");
  return previousColumn = column;
};

$(function() {
  var chart, color, configRadar, ctx;
  ctx = document.getElementById('myChart').getContext('2d');
  chart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: key,
      datasets: [
        {
          label: "Number of velo",
          backgroundColor: 'rgb(99, 99, 132)',
          borderColor: 'rgb(99, 99, 132)',
          data: values
        }
      ]
    },
    options: {
      title: {
        display: true,
        text: 'Pareto Graph : Y number of velo have been used X times during a month'
      },
      onHover: hover,
      onClick: click,
      maintainAspectRatio: false
    }
  });
  color = Chart.helpers.color;
  configRadar = {
    type: 'radar',
    data: {
      labels: ["numbers of velo in this case (%)", "average time duration (%)", "average distance (%)", "away from center (%)"],
      datasets: [
        {
          label: "98",
          backgroundColor: color("red").alpha(0.2).rgbString(),
          borderColor: "red",
          pointBackgroundColor: "red",
          data: [numbers[57],
        times[57],
        distances[57],
        away[57]]
        },
        {
          label: "1",
          backgroundColor: color("blue").alpha(0.2).rgbString(),
          borderColor: "blue",
          pointBackgroundColor: "blue",
          data: [numbers[0],
        times[0],
        distances[0],
        away[0]]
        }
      ]
    },
    options: {
      legend: {
        display: false,
        position: 'right'
      },
      title: {
        display: false,
        text: 'Comparative graph between 98 and 1'
      },
      scale: {
        ticks: {
          beginAtZero: true
        }
      }
    }
  };
  return radar = new Chart(document.getElementById("canvas"), configRadar);
});
