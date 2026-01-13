# Aura
## 🧭 Descrição

Aura é um aplicativo Flutter que permite gerenciar e monitorar dispositivos IoT via MQTT. Com ele, você pode:

- Cadastrar dispositivos (LoRa, Bluetooth, DevAddr, EUI, etc)  
- Persistir dados localmente com Hive  
- Conectar-se a um broker MQTT (ex: HiveMQ)  
- Escutar dados de localização em tempo real e mostrar no mapa (usando `flutter_map`)  
- Atualizar configurações de conexão MQTT (URL, porta, usuário, senha)

---

## ⚙️ Funcionalidades

- Registro de dispositivos com dados completos  
- Listagem de dispositivos cadastrados  
- Tela de detalhes do dispositivo com mapa mostrando localização  
- Conexão/reconexão com broker MQTT a partir das configurações salvas  
- Stream de localização (via MQTT) para atualização em tempo real  
- Persistência local usando Hive para dados de dispositivos e configurações

---

## 🚀 Como executar

### Pré-requisitos

- Flutter instalado (versão **2.x** ou superior)  
- Um broker MQTT ativo (exemplo: HiveMQ)  
- Acesso à internet  

### Instalação

1. Clone o repositório:

    ```bash
    git clone https://github.com/Rafaeros/iottracker.git
    ```

2. Instale as dependências:

    ```bash
    flutter pub get
    ```

3. Gere o código do Hive
    ```bash
    flutter pub run build_runner build
    ```

4. Execute o comando:

    ```bash
    flutter run
    ```

---

## 🔧 Configurações MQTT

Na tela de Settings do app, você pode configurar:

URL do Broker (por exemplo: seu-broker.hivemq.cloud)

Porta (ex: 8883 para TLS)

Usuário

Senha

Essas configurações são persistidas no dispositivo usando Hive e usadas para conectar ao broker via MQTTClientWrapper.

---

## 🧪 Tecnologias utilizadas

Flutter — para a interface do app

Hive — banco de dados local

mqtt_client — cliente MQTT para se conectar ao broker

flutter_map + latlong2 — para exibir mapa e marcadores

---

## 💡 Exemplos de uso

Adicione um novo dispositivo na tela “Add Device”

Vá para a lista de dispositivos e clique em um para ver os detalhes

Na tela de detalhes, o mapa mostra a localização em tempo real (se os dados MQTT estiverem sendo enviados corretamente)

Vá em Settings para alterar a conexão MQTT e reconectar

---