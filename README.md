
# 📦 PasseiCoreData

[![CI Status](https://img.shields.io/travis/95707007/PasseiCoreData.svg?style=flat)](https://travis-ci.org/95707007/PasseiCoreData)
[![Version](https://img.shields.io/cocoapods/v/PasseiCoreData.svg?style=flat)](https://cocoapods.org/pods/PasseiCoreData)
[![License](https://img.shields.io/cocoapods/l/PasseiCoreData.svg?style=flat)](https://cocoapods.org/pods/PasseiCoreData)
[![Platform](https://img.shields.io/cocoapods/p/PasseiCoreData.svg?style=flat)](https://cocoapods.org/pods/PasseiCoreData)

O **PasseiCoreData** é uma biblioteca em Swift projetada para gerenciar e criptografar modelos do Core Data, oferecendo uma solução segura e eficiente para persistência de dados no iOS.

---

## **Descrição**

Este pacote oferece um conjunto de utilitários para facilitar o gerenciamento de dados no Core Data, com foco na segurança através de criptografia integrada. Ideal para aplicações que exigem manipulação de dados confidenciais.

---

## **Exemplo de Uso**

Para rodar o projeto de exemplo, siga os passos abaixo:

1. Clone o repositório.
2. Navegue até o diretório `Example`.
3. Execute o comando `pod install`.
4. Abra o projeto no Xcode e rode o exemplo.

---

## **Requisitos**

- **Swift**: 5.0 ou superior
- **iOS**: Compatível com iOS 11.0+
- **CocoaPods** instalado

---

## **Instalação**

### **Usando CocoaPods**

PasseiCoreData está disponível no [CocoaPods](https://cocoapods.org). Para instalar, adicione a seguinte linha ao seu `Podfile`:

```ruby
pod 'PasseiCoreData'
```

Depois, execute o comando:

```bash
pod install
```

### **Manual**

Você também pode importar o projeto diretamente ao clonar o repositório e adicionar os arquivos necessários ao seu projeto.

---

## **Como Usar**

### **Exemplo Básico em Swift:**

```swift
import PasseiCoreData

let dataManager = CoreDataManager()
dataManager.saveData(object: myObject)   // Salvar dados no Core Data
dataManager.fetchData()                  // Buscar dados armazenados
```

---

## **Contribuição**

Contribuições são bem-vindas! Siga os passos abaixo para colaborar:

1. Faça um fork do projeto.
2. Crie uma branch para suas alterações (`git checkout -b minha-feature`).
3. Faça commit das alterações (`git commit -m 'Minha nova feature'`).
4. Envie as alterações para o seu fork (`git push origin minha-feature`).
5. Abra um Pull Request para revisão.

---

## **Licença**

PasseiCoreData está disponível sob a licença **MIT**. Consulte o arquivo `LICENSE` para mais informações.

---

## **Autor**

Desenvolvido por **Vagner Oliveira**  
E-mail: ziminny@gmail.com

---

## **Recursos úteis**

- [Core Data Documentation (Apple)](https://developer.apple.com/documentation/coredata/)
- [Swift.org](https://swift.org)
- [Documentação CocoaPods](https://guides.cocoapods.org/)
