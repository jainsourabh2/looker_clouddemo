# Define the database connection to be used for this model.
connection: "looker_sourabhjainceanalytics"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: looker_demo_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_demo_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Looker Demo"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: channels {}

explore: products {}

explore: stores {}

explore: customers {}

explore: old_events {}

explore: transaction_detail {
  join: stores {
    type: left_outer
    sql_on: ${transaction_detail.store_id} = ${stores.id} ;;
    relationship: many_to_one
  }

  join: customers {
    type: left_outer
    sql_on: ${transaction_detail.customer_id} = ${customers.id} ;;
    relationship: many_to_one
  }

  join: channels {
    type: left_outer
    sql_on: ${transaction_detail.channel_id} = ${channels.id} ;;
    relationship: many_to_one
  }

  join: transaction_detail__line_items {
    view_label: "Transaction Detail: Line Items"
    sql: LEFT JOIN UNNEST(${transaction_detail.line_items}) as transaction_detail__line_items ;;
    relationship: one_to_many
  }
}
