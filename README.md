
# Projeto Lógico de Banco de Dados - E-commerce

## Descrição do Projeto

Este projeto apresenta a modelagem lógica de um banco de dados para um cenário de e-commerce, desenvolvido em MySQL. O objetivo é estruturar um esquema que represente os principais elementos de um sistema de vendas online, contemplando clientes (pessoa física e jurídica), vendedores, fornecedores, produtos, formas de pagamento, pedidos e entregas.

Foram aplicados conceitos de modelagem lógica, incluindo definição de chaves primárias, estrangeiras, constraints e relacionamentos complexos para garantir a integridade e coerência dos dados.

### Pontos principais do modelo

- **Cliente**: pode ser Pessoa Física (PF) ou Pessoa Jurídica (PJ), garantindo que uma conta não possua informações de ambos os tipos simultaneamente.
- **Vendedor e Fornecedor**: possibilidade de um mesmo indivíduo atuar como vendedor e fornecedor, representado por uma tabela associativa.
- **Produto**: vinculado ao fornecedor, com controle de estoque e preço.
- **Forma de Pagamento**: clientes podem possuir múltiplas formas de pagamento cadastradas.
- **Pedido e ItemPedido**: pedidos registrados com seus respectivos itens, valor total derivado da soma dos itens.
- **Entrega**: com status e código de rastreio para acompanhamento.

---

## Estrutura das tabelas

- Cliente (cliente_id, nome, tipo_cliente, cpf, cnpj)
- Vendedor (vendedor_id, nome)
- Fornecedor (fornecedor_id, nome)
- VendedorFornecedor (vendedor_id, fornecedor_id)
- Produto (produto_id, nome, fornecedor_id, preco, estoque)
- FormaPagamento (pagamento_id, cliente_id, tipo_pagamento, detalhes)
- Pedido (pedido_id, cliente_id, vendedor_id, data_pedido, valor_total)
- ItemPedido (item_id, pedido_id, produto_id, quantidade, preco_unitario)
- Entrega (entrega_id, pedido_id, status, codigo_rastreio)

---

## Regras e Constraints importantes

- Clientes são classificados como PF ou PJ, com validação para garantir exclusividade das informações.
- Pedido calcula automaticamente o valor total com base nos itens relacionados.
- Relacionamento entre vendedor e fornecedor é representado por tabela associativa para casos onde um mesmo indivíduo pode ser ambos.

---

## Exemplos de Queries

1. **Quantos pedidos foram feitos por cada cliente?**

```sql
SELECT c.nome, COUNT(p.pedido_id) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
ORDER BY total_pedidos DESC;
