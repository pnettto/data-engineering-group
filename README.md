# **Scottish Wind Energy**  **A data engineering report**

## **Executive Summary**

This report documents the comprehensive data engineering project focused on analyzing Scottish wind energy patterns and performance. The project involved collecting, processing, and analyzing multiple data sources to generate actionable insights for Scotland's energy infrastructure planning and wind farm optimization.

---

## **1\. Introduction**

### **1.1 Group Introduction**

Our team brought together expertise in data engineering, analytics, and renewable energy systems to tackle the complex challenge of understanding Scotland's wind energy landscape. The project aimed to create a comprehensive data pipeline that could provide insights into wind farm performance, energy consumption patterns, and optimization opportunities.

### **1.2 Group Organization**

The team adopted modern project management practices to ensure efficient collaboration and delivery:

**Roles and Responsibilities:**

Scrum Master:

* Led daily meetings and sprint planning  
* Set agendas, tracked goals, and supported team progress

Product Owner: 

* Handled governance, privileges, and user access  
* Managed timelines, communications, and deliverables

Data Engineers / Analysts: 

* Discovered, extracted, and cleaned data  
* Refined data, engineered features, and generated insights

Dashboard / Visualization Creator: 

* Designed clear, interactive dashboards  
* Visualized insights aligned with stakeholder needs

**Project Management Tools:**

* **Trello:** Used for task tracking, sprint planning, and progress monitoring  
* **Communication:** Regular stand-up meetings and documentation sharing  
* **Development Environment:** Snowflake for data warehousing and processing.

---

## **2\. Governance**

### **2.1 Function**

Our governance framework laid out clear procedures for data management, quality assurance, and project coordination. Key governance functions included:

* Data Quality Standards: Establishing criteria for data validation and cleansing.  
* Schema Management: Defining consistent naming conventions and data structures.  
* Process Documentation: Creating reproducible workflows and procedures.

We assigned one team member to oversee all database privileges, creating both the database and its schemas. This individual was responsible for granting necessary permissions to all team members and establishing a centralized common role to facilitate collaboration. We utilized stored procedures to automate the privilege granting process.

### **2.2 Challenges and Learnings**

Key challenges encountered during the project included:

* Efficiently managing large-scale datasets (exceeding 5GB annually).  
* Standardizing data from multiple file types.

Our key learnings from these experiences were:

* The critical importance of early data standardization.  
* The necessity for comprehensive documentation.  
* The value of iterative development and regular team synchronization.  
* The benefits derived from combining automated and manual data processing.

Relevant file:

* [governance\_procedure.sql](https://github.com/pnettto/data-engineering-group/blob/main/governance/governance_procedure.sql) 

---

## **3\. Data Engineering**

### **3.1 Discovery Phase**

The data discovery process involved identifying and evaluating multiple data sources relevant to Scottish wind energy analysis.

#### **3.1.1 WeDoWind Open Data on Wind Farms**

WeDoWind provided comprehensive wind farm operational data from a wind park in Hill of Towie, offering detailed insights into turbine performance, energy generation, and operational metrics. This dataset served as the primary source for wind farm performance analysis.

Relevant links:

* Original data source: [https://zenodo.org/records/14870023](https://zenodo.org/records/14870023)

#### **3.1.2 Scottish Energy Industries Data Generation**

The team leveraged AI techniques to generate supplementary datasets. This approach involved:

* Identifying data patterns from existing sources.  
* Using machine learning models to generate realistic industry data.  
* Validating generated data against known benchmarks.

Relevant links:

* Generated JSON: [scotland\_national\_grid\_energy\_2024.json](https://github.com/pnettto/data-engineering-group/blob/main/raw/files/scotland_national_grid_energy_2024.json)   
* Transforming JSON into a  flattened structure: [JSON\_to\_table.sql](https://github.com/pnettto/data-engineering-group/blob/main/raw/data_cleaning/JSON_to_table.sql) 

#### **3.1.3 Open-Meteo Weather Data Integration**

Open-Meteo provided meteorological data to correlate weather patterns with energy generation. This integration addressed Snowflake's Marketplace limitations in wind-specific data. 

Relevant links:

* Original data source: [https://open-meteo.com/](https://open-meteo.com/)   
* Combined CSV files: [scotland\_weather\_2024\_merged\_cleaned.csv](https://github.com/pnettto/data-engineering-group/blob/main/raw/files/scotland_weather_2024_merged_cleaned.csv) 

### **3.2 Data Refinement Process (PREP Schema)**

#### **3.2.1 Data Cleaning Methodologies**

The refinement process looked something like this:

**Worksheet-Based Cleaning:**

* Manual review and correction of data anomalies  
* Domain expert validation of questionable values  
* Documentation of cleaning decisions

**Python-Based Manipulation:**

* Pandas library for systematic data transformations  
  * Relevant code: [data\_cleaning/merge\_open\_meteo.py](https://github.com/pnettto/data-engineering-group/blob/main/raw/data_cleaning/merge_open_meteo.py) 

**Stored Procedures:**

* Database-level data validation and cleaning  
* Performance-optimized processing for large datasets  
* Reusable cleaning logic for ongoing data updates  
* Wind farm data cleaning procedures:  
  * [TURBINES\_CLEANUP\_01\_CREATE\_TABLE\_NON\_NULL\_COLUMNS.sql](https://github.com/pnettto/data-engineering-group/blob/main/prep/procedures/TURBINES_CLEANUP_01_CREATE_TABLE_NON_NULL_COLUMNS.sql)  
  * [TURBINES\_CLEANUP\_02\_DEDUPLICATE\_TIMESTAMPS.sql](https://github.com/pnettto/data-engineering-group/blob/main/prep/procedures/TURBINES_CLEANUP_02_DEDUPLICATE_TIMESTAMPS.sql)  
  * [TURBINES\_CLEANUP\_03\_REMOVE\_SEPTEMBER.sql](https://github.com/pnettto/data-engineering-group/blob/main/prep/procedures/TURBINES_CLEANUP_03_REMOVE_SEPTEMBER.sql)  
  * [TURBINES\_CLEANUP\_04\_CREATE\_FINAL\_VIEW.sql](https://github.com/pnettto/data-engineering-group/blob/main/prep/procedures/TURBINES_CLEANUP_04_CREATE_FINAL_VIEW.sql)  
  * [TURBINES\_CLEANUP\_ALL.sql](https://github.com/pnettto/data-engineering-group/blob/main/prep/procedures/TURBINES_CLEANUP_ALL.sql)

#### **3.2.2 Definition of "Refined" Data**

Refined data maintains the comprehensive nature of raw data while ensuring:

* Consistency in data formats and units  
* Removal of duplicates and erroneous entries  
* Standardized naming conventions  
* Complete documentation of transformations applied

### **3.3 Model Schema and Views Creation**

#### **3.3.1 Definition of Model/Delivery Data**

Model data represents the final, analysis-ready datasets optimized for visualization and business intelligence applications. Key characteristics include:

* Pre-aggregated metrics for common analyses  
* Optimized query performance  
* Business-friendly naming conventions

#### **3.3.2 Business Value Generation**

**Analysis of Scottish Energy Usage:**

* Identification of consumption sources  
* Regional variation analysis

**Energy Mix Optimization Insights:**

* Wind energy contribution potential  
* Hill of Towie makes a meaningful contribution to overall energy production

**Hill of Towie Performance Analysis:**

* Operational efficiency metrics

**Business Opportunity Identification:**

* Energy storage investment potential  
* Policy recommendation development

#### **3.3.3 Showcase Views**

Views list: 

*    
* [HILLOFTOWIE\_WEATHER\_MONTHLY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/HILLOFTOWIE_WEATHER_MONTHLY.sql)  
* [NON\_RENEWABLE\_OUTPUT\_BY\_MONTH.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/NON_RENEWABLE_OUTPUT_BY_MONTH.sql)  
* [TURBINES\_TOTAL\_OUTPUT\_BY\_MONTH.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/TURBINES_TOTAL_OUTPUT_BY_MONTH.sql)  
* [TURBINES\_TOTAL\_OUTPUT\_BY\_TURBINE.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/TURBINES_TOTAL_OUTPUT_BY_TURBINE.sql)  
* [VW\_AVG\_MONTHLY\_WINDSPEED.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_AVG_MONTHLY_WINDSPEED.sql)  
* [VW\_EMISSIONS\_INTENSITY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_EMISSIONS_INTENSITY.sql)  
* [VW\_ENERGY\_SOURCE\_MIX.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_ENERGY_SOURCE_MIX.sql)  
* [VW\_INVERNESS\_VS\_ABERDEEN\_MONTHLY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_INVERNESS_VS_ABERDEEN_MONTHLY.sql)  
* [VW\_INVERNESS\_VS\_ABERDEEN\_WINDSPEED.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_INVERNESS_VS_ABERDEEN_WINDSPEED.sql)  
* [VW\_LOCATION\_SUMMARY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_LOCATION_SUMMARY.sql)  
* [VW\_SCOTLAND\_ENERGY\_SUMMARY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_SCOTLAND_ENERGY_SUMMARY.sql)  
* [VW\_SCOTLAND\_MONTHLY\_WINDSPEED\_TREND.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_SCOTLAND_MONTHLY_WINDSPEED_TREND.sql)  
* [VW\_SCOTLAND\_RENEWABLE\_ENERGY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_SCOTLAND_RENEWABLE_ENERGY.sql)  
* [VW\_TURBINE\_AVAILABILITY\_TRENDS.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_TURBINE_AVAILABILITY_TRENDS.sql)  
* [VW\_TURBINE\_STOP\_CAUSES.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_TURBINE_STOP_CAUSES.sql)  
* [VW\_WIND\_FARM\_VS\_ENERGY\_INDUSTRIES.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/VW_WIND_FARM_VS_ENERGY_INDUSTRIES.sql)  
* [WIND\_DIRECTION\_SUMMARY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/WIND_DIRECTION_SUMMARY.sql)  
* [WIND\_FARM\_VS\_NON\_RENEWABLES.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/WIND_FARM_VS_NON_RENEWABLES.sql)  
* [WIND\_SPEED\_MEAN\_BY\_DAY.sql](https://github.com/pnettto/data-engineering-group/blob/main/model/views/WIND_SPEED_MEAN_BY_DAY.sql)

### **3.4 Dashboard Development**

The dashboard provides stakeholders with intuitive access to key insights and metrics. Features include:

**Performance Metrics:**

* Wind farm performance indicators  
* Historical trend analysis  
* Comparative performance across different locations

**Regional Analysis:**

* Geographic distribution of wind resources  
* Regional consumption patterns  
* Grid connectivity mapping

**Predictive Analytics:**

* Investment and environmental opportunity identification

---

## **4\. Conclusion**

### **4.1 Project Outcomes**

**Key Achievement:** The project successfully generated valuable insights into Scotland's wind energy landscape, and the analysis revealed the need for additional data sources.

**Delivered Insights:**

* Understanding of Hill of Towie wind farm performance  
* Analysis of seasonal wind patterns affecting energy generation

**Technical Accomplishments:**

* Integration of multiple data sources  
* Creation of analytical frameworks  
* Establishment of data governance procedures

### **4.2 Retrospective Analysis**

#### **4.2.1 Practices to Start**

* Standardization of processes (naming conventions, schema definitions, using table and column descriptions)  
* Clearly identify the problems  
* Using version control (GitHub)

#### **4.2.2 Practices to Stop**

* Reduce dependency on third-party data marketplaces

#### **4.2.3 Practices to Continue**

Agile techniques

* Stand up meetings  
* Trello / Scrum  
* Pair programming     