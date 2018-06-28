class ManifestController < ApplicationController
  # GET /manifest.json
  def index
    render json: {
      "shortName": "Nervos Chain",
      "name": "Nervos Chain",
      "chainId": "1",
      "httpProvider": "http://47.97.108.229:1337",
      "blockViewer": "https://etherscan.io/",
      "networkId": "manifest",
      "chainset": [{
                     "chainId": "12345",
                     "networkId": "ignore",
                     "httpProvider": "http://xxx.com"
                   }],
      "icon": "http://7xq40y.com1.z0.glb.clouddn.com/23.pic.jpg",
      "entry": "index.html",
      "provider": "https://etherscan.io/"
    }
  end
end
